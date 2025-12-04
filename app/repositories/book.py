"""Repository for Book database operations."""

from typing import Sequence

from advanced_alchemy.repository import SQLAlchemySyncRepository
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models import Book, Review


class BookRepository(SQLAlchemySyncRepository[Book]):
    """Repository for book database operations."""

    model_type = Book

    def get_available_books(self) -> Sequence[Book]:
        """Return books with stock > 0."""
        return self.list(Book.stock > 0)

    def find_by_category(self, category_id: int) -> Sequence[Book]:
        """Return books that belong to a given category."""
        return self.list(Book.categories.any(id=category_id))

    def get_most_reviewed_books(self, limit: int = 10) -> Sequence[Book]:
        """Return books ordered by number of reviews (desc)."""
        stmt = (
            select(Book)
            .outerjoin(Review, Review.book_id == Book.id)
            .group_by(Book.id)
            .order_by(func.count(Review.id).desc())
            .limit(limit)
        )
        return list(self.session.scalars(stmt).all())

    def update_stock(self, book_id: int, quantity: int) -> Book:
        """Update stock of a given book.

        quantity puede ser positivo (sumar stock) o negativo (restar stock).
        Lanza ValueError si el stock resultante quedaría negativo.
        """
        book = self.get(book_id)
        new_stock = (book.stock or 0) + quantity
        if new_stock < 0:
            raise ValueError("El stock no puede quedar negativo.")

        book.stock = new_stock
        self.session.add(book)
        self.session.commit()
        self.session.refresh(book)
        return book

    def search_by_author(self, author_name: str) -> Sequence[Book]:
        """Search books by author name using ILIKE (partial search)."""
        pattern = f"%{author_name}%"
        return self.list(Book.author.ilike(pattern))


async def provide_book_repo(db_session: Session) -> BookRepository:
    """Provide book repository instance with auto-commit."""
    return BookRepository(session=db_session, auto_commit=True)
