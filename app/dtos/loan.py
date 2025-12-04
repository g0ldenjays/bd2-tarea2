"""Data Transfer Objects for Loan endpoints."""

from advanced_alchemy.extensions.litestar import SQLAlchemyDTO, SQLAlchemyDTOConfig

from app.models import Loan


class LoanReadDTO(SQLAlchemyDTO[Loan]):
    """DTO for reading loan data."""

    config = SQLAlchemyDTOConfig()


class LoanCreateDTO(SQLAlchemyDTO[Loan]):
    """DTO for creating loans."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "user", "book", "due_date", "return_at", "fine_amount", "status"},
    ) # A pesar de que return_dt puede ser nulo y lo excluyo, la API sigue reclamando al enviar un string vacío.
    # En un futuro se verá solución, de momento se puede borrar directamente del body el campo si no se quiere enviar.  


class LoanUpdateDTO(SQLAlchemyDTO[Loan]):
    """DTO for updating loans with partial data."""

    config = SQLAlchemyDTOConfig(
        include={"status"},
        partial=True,
    )
