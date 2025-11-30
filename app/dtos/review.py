"""Data Transfer Objects for Review endpoints."""

from advanced_alchemy.extensions.litestar import SQLAlchemyDTO, SQLAlchemyDTOConfig

from app.models import Review


class ReviewReadDTO(SQLAlchemyDTO[Review]):
    """DTO for reading review data, including user and book relations."""

    config = SQLAlchemyDTOConfig(
        exclude={"created_at", "updated_at"},
    )


class ReviewCreateDTO(SQLAlchemyDTO[Review]):
    """DTO for creating reviews."""

    # se manda user_id y book_id como enteros
    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "user", "book"},
    )


class ReviewUpdateDTO(SQLAlchemyDTO[Review]):
    """DTO for updating reviews (partial)."""

    config = SQLAlchemyDTOConfig(
        exclude={"id", "created_at", "updated_at", "user", "book"},
        partial=True,
    )
