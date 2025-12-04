"""Controller for Loan endpoints."""

from typing import Sequence
from datetime import date, timedelta

from advanced_alchemy.exceptions import DuplicateKeyError, NotFoundError
from litestar import Controller, delete, get, patch, post
from litestar.di import Provide
from litestar.dto import DTOData

from app.controllers import duplicate_error_handler, not_found_error_handler
from app.dtos.loan import LoanCreateDTO, LoanReadDTO, LoanUpdateDTO
from app.models import Loan, LoanStatus
from app.repositories.loan import LoanRepository, provide_loan_repo


class LoanController(Controller):
    """Controller for loan management operations."""

    path = "/loans"
    tags = ["loans"]
    return_dto = LoanReadDTO
    dependencies = {"loans_repo": Provide(provide_loan_repo)}
    exception_handlers = {
        NotFoundError: not_found_error_handler,
        DuplicateKeyError: duplicate_error_handler,
    }

    @get("/")
    async def list_loans(self, loans_repo: LoanRepository) -> Sequence[Loan]:
        """Get all loans."""
        return loans_repo.list()

    @get("/{id:int}")
    async def get_loan(self, id: int, loans_repo: LoanRepository) -> Loan:
        """Get a loan by ID."""
        return loans_repo.get(id)

    @post("/", dto=LoanCreateDTO)
    async def create_loan(self,data: DTOData[Loan],loans_repo: LoanRepository) -> Loan:
        """Create a new loan.

        - Calcula due_date como loan_dt + 14 días.
        - Deja fine_amount en None.
        - Deja status en ACTIVE.
        """
        loan = data.create_instance()

        # Si no vino loan_dt, usamos la fecha de hoy
        if loan.loan_dt is None:
            loan.loan_dt = date.today()

        # due_date = 14 días después de loan_dt
        loan.due_date = loan.loan_dt + timedelta(days=14)

        # Por claridad hacemos explícitos estos defaults
        loan.status = LoanStatus.ACTIVE
        loan.fine_amount = None

        return loans_repo.add(loan)

    @patch("/{id:int}", dto=LoanUpdateDTO)
    async def update_loan(self,id: int,data: DTOData[Loan],loans_repo: LoanRepository) -> Loan:
        """Update loan status by ID.

        El DTO solo permite actualizar 'status', así que no se tocan otros campos.
        """
        payload = data.as_builtins()
        loan, _ = loans_repo.get_and_update(match_fields="id", id=id, **payload)
        return loan

    @delete("/{id:int}")
    async def delete_loan(self, id: int, loans_repo: LoanRepository) -> None:
        """Delete a loan by ID."""
        loans_repo.delete(id)

    @get("/active")
    async def get_active_loans(self,loans_repo: LoanRepository) -> Sequence[Loan]:
        """Get all ACTIVE loans."""
        return loans_repo.get_active_loans()

    @get("/overdue")
    async def get_overdue_loans(self,loans_repo: LoanRepository) -> Sequence[Loan]:
        """Get all overdue loans, marking ACTIVE + vencidos como OVERDUE."""
        return loans_repo.get_overdue_loans()

    @get("/{id:int}/fine")
    async def get_loan_fine(self,id: int,loans_repo: LoanRepository) -> dict:
        """Calculate fine for a loan."""
        fine = loans_repo.calculate_fine(id)
        return {"loan_id": id, "fine": str(fine)}

    @post("/{id:int}/return")
    async def return_book(self,id: int,loans_repo: LoanRepository) -> Loan:
        """Process a book return for a given loan."""
        return loans_repo.return_book(id)

    @get("/user/{user_id:int}")
    async def get_user_loan_history(self,user_id: int,loans_repo: LoanRepository) -> Sequence[Loan]:
        """Get full loan history for a user, ordered by loan date."""
        return loans_repo.get_user_loan_history(user_id)
