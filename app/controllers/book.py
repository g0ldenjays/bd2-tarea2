"""Controller for Book endpoints."""

from typing import Annotated, Sequence
from datetime import datetime

from advanced_alchemy.exceptions import DuplicateKeyError, NotFoundError
from advanced_alchemy.filters import LimitOffset
from litestar import Controller, delete, get, patch, post
from litestar.di import Provide
from litestar.dto import DTOData
from litestar.exceptions import HTTPException
from litestar.params import Parameter

from app.controllers import duplicate_error_handler, not_found_error_handler
from app.dtos.book import BookCreateDTO, BookReadDTO, BookUpdateDTO
from app.models import Book, BookStats
from app.repositories.book import BookRepository, provide_book_repo


class BookController(Controller):
    """Controller for book management operations."""

    path = "/books"
    tags = ["books"]
    return_dto = BookReadDTO
    dependencies = {"books_repo": Provide(provide_book_repo)}
    exception_handlers = {
        NotFoundError: not_found_error_handler,
        DuplicateKeyError: duplicate_error_handler,
    }

    @get("/")
    async def list_books(self, books_repo: BookRepository) -> Sequence[Book]:
        """Get all books."""
        return books_repo.list()

    @get("/{id:int}")
    async def get_book(self, id: int, books_repo: BookRepository) -> Book:
        """Get a book by ID."""
        return books_repo.get(id)

    @post("/", dto=BookCreateDTO)
    async def create_book( self, data: DTOData[Book], books_repo: BookRepository) -> Book:
        """Create a new book."""
        payload = data.as_builtins()

        # año de publicación válido
        current_year = datetime.now().year
        published_year = payload.get("published_year")
        if published_year is None or not (1000 <= published_year <= current_year):
            raise HTTPException(
                detail=f"El año de publicación debe estar entre 1000 y {current_year}",
                status_code=400,
            )

        # stock > 0
        stock = payload.get("stock", 1)
        if stock is None or stock <= 0:
            raise HTTPException(
                detail="El stock debe ser mayor que 0",
                status_code=400,
            )

        # idioma
        language = payload.get("language")
        if not isinstance(language, str) or len(language) != 2:
            raise HTTPException(
                detail="El idioma debe ser un código de 2 letras (por ejemplo: 'es', 'en', 'fr').",
                status_code=400,
            )

        return books_repo.add(data.create_instance())

    @patch("/{id:int}", dto=BookUpdateDTO)
    async def update_book( self, id: int, data: DTOData[Book], books_repo: BookRepository) -> Book:
        """Update a book by ID."""
        payload = data.as_builtins()
        current_year = datetime.now().year

        # año de publicación válido
        if "published_year" in payload and payload["published_year"] is not None:
            if not (1000 <= payload["published_year"] <= current_year):
                raise HTTPException(
                    detail=f"El año de publicación debe estar entre 1000 y {current_year}",
                    status_code=400,
                )

        # stock >= 0
        if "stock" in payload and payload["stock"] is not None:
            if payload["stock"] < 0:
                raise HTTPException(
                    detail="El stock no puede ser negativo",
                    status_code=400,
                )

        # idioma
        if "language" in payload and payload["language"] is not None:
            language = payload["language"]
            if not isinstance(language, str) or len(language) != 2:
                raise HTTPException(
                    detail="El idioma debe ser un código de 2 letras (por ejemplo: 'es', 'en', 'fr').",
                    status_code=400,
                )

        book, _ = books_repo.get_and_update(match_fields="id", id=id, **payload)
        return book

    @delete("/{id:int}")
    async def delete_book(self, id: int, books_repo: BookRepository) -> None:
        """Delete a book by ID."""
        books_repo.delete(id)

    @get("/search/")
    async def search_book_by_title(
        self,
        title: str,
        books_repo: BookRepository,
    ) -> Sequence[Book]:
        """Search books by title."""
        return books_repo.list(Book.title.ilike(f"%{title}%"))

    @get("/filter")
    async def filter_books_by_year(
        self,
        year_from: Annotated[int, Parameter(query="from")],
        to: int,
        books_repo: BookRepository,
    ) -> Sequence[Book]:
        """Filter books by published year."""
        return books_repo.list(Book.published_year.between(year_from, to))

    @get("/recent")
    async def get_recent_books( self, limit: Annotated[int, Parameter(query="limit", default=10, ge=1, le=50)], books_repo: BookRepository) -> Sequence[Book]:
        """Get most recent books."""
        return books_repo.list(
            LimitOffset(offset=0, limit=limit),
            order_by=Book.created_at.desc(),
        )

    @get("/stats")
    async def get_book_stats(self,books_repo: BookRepository) -> BookStats:
        """Get statistics about books."""
        total_books = books_repo.count()
        if total_books == 0:
            return BookStats(
                total_books=0,
                average_pages=0,
                oldest_publication_year=None,
                newest_publication_year=None,
            )

        books = books_repo.list()

        average_pages = sum(book.pages for book in books) / total_books
        oldest_year = min(book.published_year for book in books)
        newest_year = max(book.published_year for book in books)

        return BookStats(
            total_books=total_books,
            average_pages=average_pages,
            oldest_publication_year=oldest_year,
            newest_publication_year=newest_year,
        )

    @get("/available")
    async def get_available_books(self,books_repo: BookRepository) -> Sequence[Book]:
        """Get books with stock > 0."""
        return books_repo.get_available_books()

    @get("/by-category/{category_id:int}")
    async def get_books_by_category(self,category_id: int,books_repo: BookRepository) -> Sequence[Book]:
        """Get books that belong to a given category."""
        return books_repo.find_by_category(category_id)

    @get("/most-reviewed")
    async def get_most_reviewed_books(self,limit: Annotated[int, Parameter(query="limit", ge=1, le=50, default=10)],books_repo: BookRepository) -> Sequence[Book]:
        """Get books ordered by number of reviews (desc)."""
        return books_repo.get_most_reviewed_books(limit=limit)

    @patch("/{id:int}/stock")
    async def update_book_stock(self,id: int,quantity: Annotated[int, Parameter(query="quantity")],books_repo: BookRepository) -> Book:
        """Update stock for a book (quantity can be positive or negative)."""
        try:
            return books_repo.update_stock(book_id=id, quantity=quantity)
        except ValueError as exc:
            # stock no puede quedar negativo
            raise HTTPException(status_code=400, detail=str(exc))

    @get("/search/author")
    async def search_books_by_author(self,author_name: Annotated[str, Parameter(query="author_name")],books_repo: BookRepository) -> Sequence[Book]:
        """Search books by author name (partial match)."""
        return books_repo.search_by_author(author_name)
