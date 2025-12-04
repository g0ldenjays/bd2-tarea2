"""Repository for Loan database operations."""

from typing import Sequence
from datetime import date
from decimal import Decimal

from advanced_alchemy.repository import SQLAlchemySyncRepository
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models import Loan, LoanStatus


class LoanRepository(SQLAlchemySyncRepository[Loan]):
    """Repository for loan database operations."""

    model_type = Loan

    # préstamos activos
    def get_active_loans(self) -> Sequence[Loan]:
        """Return loans with status ACTIVE."""
        return self.list(Loan.status == LoanStatus.ACTIVE)

    # préstamos vencidos, marcar como overdue
    def get_overdue_loans(self) -> Sequence[Loan]:
        """Return loans that are overdue and mark them as OVERDUE."""
        today = date.today()
        stmt = select(Loan).where(
            Loan.status == LoanStatus.ACTIVE,
            Loan.due_date < today,
        )
        loans = list(self.session.scalars(stmt).all())

        if not loans:
            return loans

        for loan in loans:
            loan.status = LoanStatus.OVERDUE
            self.session.add(loan)

        self.session.commit()

        for loan in loans:
            self.session.refresh(loan)

        return loans

    # helper para no repetir lógica de multa
    def _calculate_fine_for_loan(self, loan: Loan) -> Decimal:
        """Internal helper: calculate fine for a given loan instance."""
        # si no hay atraso, multa 0
        ref_date = loan.return_dt or date.today()
        if ref_date <= loan.due_date:
            return Decimal("0.00")

        days_late = (ref_date - loan.due_date).days
        return Decimal("500") * days_late

    # calcular multa de un préstamo
    def calculate_fine(self, loan_id: int) -> Decimal:
        """Calculate fine for a loan: $500 per day of delay."""
        loan = self.get(loan_id)
        return self._calculate_fine_for_loan(loan)

    # procesar devolución y actualizar stock
    def return_book(self, loan_id: int) -> Loan:
        """Process book return.

        - status → RETURNED
        - return_dt → hoy
        - fine_amount calculado y guardado (si corresponde)
        - incrementa stock del libro asociado
        """
        loan = self.get(loan_id)

        # si ya está devuelto, retorna
        if loan.status == LoanStatus.RETURNED:
            return loan

        # fecha de devolución = hoy
        loan.return_dt = date.today()

        # calcular multa en base a return_dt y due_date
        fine = self._calculate_fine_for_loan(loan)
        loan.fine_amount = fine if fine > 0 else None

        loan.status = LoanStatus.RETURNED

        # incrementar stock del libro
        if loan.book is not None:
            if loan.book.stock is None:
                loan.book.stock = 0
            loan.book.stock += 1
            self.session.add(loan.book)

        self.session.add(loan)
        self.session.commit()
        self.session.refresh(loan)

        return loan

    # historial de préstamos de un usuario
    def get_user_loan_history(self, user_id: int) -> Sequence[Loan]:
        """Return a user's full loan history ordered by loan date (newest first)."""
        stmt = (
            select(Loan)
            .where(Loan.user_id == user_id)
            .order_by(Loan.loan_dt.desc())
        )
        return list(self.session.scalars(stmt).all())


async def provide_loan_repo(db_session: Session) -> LoanRepository:
    """Provide loan repository instance with auto-commit."""
    return LoanRepository(session=db_session, auto_commit=True)
