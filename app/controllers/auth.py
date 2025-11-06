from litestar import Controller, post
from litestar.di import Provide

from app.models import Login
from app.repositories.user import UserRepository, provide_user_repo
from app.security import password_hasher


class AuthController(Controller):
    path = "/auth"
    tags = ["auth"]

    @post(dependencies={"users_repo": Provide(provide_user_repo)})
    async def login(self, data: Login, users_repo: UserRepository) -> dict:
        user = users_repo.get_one(username = data.username)
        if password_hasher.verify(data.password, user.password):
            return {"message": "Inicio de sesión exitoso"}
        
        return {"message": "Contraseña incorrecta"}