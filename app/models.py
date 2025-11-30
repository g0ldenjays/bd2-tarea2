"""Database models for the library management system."""

from dataclasses import dataclass
from datetime import date, datetime

from advanced_alchemy.base import BigIntAuditBase
from sqlalchemy import ForeignKey, Column, Table
from sqlalchemy.orm import Mapped, mapped_column, relationship

# Tabla intermedia para la relación many-to-many entre books y categories
book_categories = Table(
    "book_categories",
    BigIntAuditBase.metadata,
    Column("book_id", ForeignKey("books.id"), primary_key=True),
    Column("category_id", ForeignKey("categories.id"), primary_key=True),
)

class User(BigIntAuditBase):
    """User model with audit fields."""

    __tablename__ = "users"

    username: Mapped[str] = mapped_column(unique=True)
    fullname: Mapped[str]
    password: Mapped[str]

    loans: Mapped[list["Loan"]] = relationship(back_populates="user")


class Book(BigIntAuditBase):
    """Book model with audit fields."""

    __tablename__ = "books"

    title: Mapped[str] = mapped_column(unique=True)
    author: Mapped[str]
    isbn: Mapped[str] = mapped_column(unique=True)
    pages: Mapped[int]
    published_year: Mapped[int]

    loans: Mapped[list["Loan"]] = relationship(back_populates="book")

    categories: Mapped[list["Category"]] = relationship(
        secondary=book_categories,
        back_populates="books",
    )


class Loan(BigIntAuditBase):
    """Loan model with audit fields."""

    __tablename__ = "loans"

    loan_dt: Mapped[date] = mapped_column(default=datetime.today)
    return_dt: Mapped[date | None]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    book_id: Mapped[int] = mapped_column(ForeignKey("books.id"))

    user: Mapped[User] = relationship(back_populates="loans")
    book: Mapped[Book] = relationship(back_populates="loans")

class Category(BigIntAuditBase):
    """Category model for grouping books."""

    __tablename__ = "categories"

    # Hereda id, created_at, updated_at desde BigIntAuditBase
    name: Mapped[str] = mapped_column(unique=True)
    description: Mapped[str | None] = mapped_column(nullable=True)

    books: Mapped[list["Book"]] = relationship(
        secondary=book_categories,
        back_populates="categories",
    )


@dataclass
class PasswordUpdate:
    """Password update request."""

    current_password: str
    new_password: str


@dataclass
class BookStats:
    """Book statistics data."""

    total_books: int
    average_pages: float
    oldest_publication_year: int | None
    newest_publication_year: int | None
