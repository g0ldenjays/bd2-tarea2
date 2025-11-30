"""Controller for Review endpoints."""

from typing import Sequence

from advanced_alchemy.exceptions import DuplicateKeyError, NotFoundError
from litestar import Controller, delete, get, patch, post
from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException

from app.controllers import duplicate_error_handler, not_found_error_handler
from app.dtos.review import ReviewCreateDTO, ReviewReadDTO, ReviewUpdateDTO
from app.models import Review
from app.repositories.review import ReviewRepository, provide_review_repo


class ReviewController(Controller):
    """Controller for review management operations."""

    path = "/reviews"
    tags = ["reviews"]
    return_dto = ReviewReadDTO
    dependencies = {"reviews_repo": Provide(provide_review_repo)}
    exception_handlers = {
        NotFoundError: not_found_error_handler,
        DuplicateKeyError: duplicate_error_handler,
    }

    @get("/")
    async def list_reviews(self, reviews_repo: ReviewRepository) -> Sequence[Review]:
        """Get all reviews."""
        return reviews_repo.list()

    @get("/{id:int}")
    async def get_review(self, id: int, reviews_repo: ReviewRepository) -> Review:
        """Get a review by ID."""
        return reviews_repo.get(id)

    @post("/", dto=ReviewCreateDTO)
    async def create_review(
        self,
        data: DTOData[Review],
        reviews_repo: ReviewRepository,
    ) -> Review:
        """Create a new review."""
        payload = data.as_builtins()

        # Validación de rating
        rating = payload.get("rating")
        if rating is None or not (1 <= rating <= 5):
            raise HTTPException(status_code=400, detail="Rating must be between 1 and 5")

        review = Review(**payload)
        return reviews_repo.add(review)

    @patch("/{id:int}", dto=ReviewUpdateDTO)
    async def update_review(
        self,
        id: int,
        data: DTOData[Review],
        reviews_repo: ReviewRepository,
    ) -> Review:
        """Update a review by ID."""
        payload = data.as_builtins()

        # Validación de rating en update
        if "rating" in payload and payload["rating"] is not None:
            rating = payload["rating"]
            if not (1 <= rating <= 5):
                raise HTTPException(status_code=400, detail="Rating must be between 1 and 5")

        review, _ = reviews_repo.get_and_update(
            match_fields="id",
            id=id,
            **payload,
        )
        return review

    @delete("/{id:int}")
    async def delete_review(self, id: int, reviews_repo: ReviewRepository) -> None:
        """Delete a review by ID."""
        reviews_repo.delete(id)
