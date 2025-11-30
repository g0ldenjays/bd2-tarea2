"""Main Litestar application for library management."""

from litestar import Litestar, get
from litestar.openapi import OpenAPIConfig
from litestar.openapi.plugins import ScalarRenderPlugin

from app.config import settings
from app.controllers.auth import AuthController
from app.controllers.book import BookController
from app.controllers.loan import LoanController
from app.controllers.user import UserController
from app.controllers.category import CategoryController
from app.controllers.review import ReviewController 
from app.db import sqlalchemy_plugin
from app.security import oauth2_auth

# Endpoint de raíz para solucionar error de raíz vacía
@get("/", tags=["root"])
async def root() -> dict[str, str]:
    """Root endpoint for basic API health check."""
    return {
        "message": "Library API running successfully!"
    }


openapi_config = OpenAPIConfig(
    title="Mi API",
    version="0.1",
    render_plugins=[
        ScalarRenderPlugin(),
    ],
)

app = Litestar(
    route_handlers=[
        root,
        UserController,
        BookController,
        LoanController,
        AuthController,
        CategoryController,
        ReviewController,
    ],
    openapi_config=openapi_config,
    debug=settings.debug,
    plugins=[sqlalchemy_plugin],
    #on_app_init=[oauth2_auth.on_app_init],
)
