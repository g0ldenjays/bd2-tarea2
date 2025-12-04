## Iván Gallardo, 4 de Diciembre 2025
### Descripción general del trabajo

Este proyecto implementa una API REST para la gestión de una biblioteca utilizando **Litestar**, **SQLAlchemy**, **Alembic** y **PostgreSQL**.
Además de la funcionalidad base incluida en el repositorio original, se agregaron:

* Modelo `Category` y relación **muchos a muchos** entre `Book` y `Category` (`book_categories`).
* Ampliación del modelo `Book` con campos adicionales: `stock`, `description`, `publisher`, `language`, entre otros.
* Modelo `Review` para registrar reseñas de usuarios sobre libros (con rating y comentario).
* Extensión del modelo `User` con información de contacto (`email`, `phone`, `address`) y el flag `is_active`.
* Extensión del modelo `Loan` con campos `due_date`, `fine_amount` y `status` basado en el enum `LoanStatus` (`ACTIVE`, `RETURNED`, `OVERDUE`).
* Nuevos métodos en los repositorios (`BookRepository`, `LoanRepository`) para búsquedas avanzadas, actualización de stock, préstamos vencidos, cálculo de multas, historial de usuario, etc.
* Endpoints adicionales en los controladores para exponer estas operaciones.
* Base de datos inicial con datos de ejemplo (categorías, libros, usuarios, préstamos y reseñas) exportada en el archivo **`initial_data.sql`**, siguiendo el formato de ISBN solicitado (`ISBN-BD2-2025-XXXX`).

Las contraseñas de los usuarios se almacenan utilizando **hash Argon2**, y se implementan validaciones en los DTOs y controladores (por ejemplo, año de publicación en un rango válido, stock no negativo, uso de `due_date` calculado automáticamente, etc.).

---

### Decisiones de diseño

* Se utilizó el patrón **Repository** para encapsular la lógica de acceso a datos y mantener los controladores lo más delgados posible.
* Los **DTOs** de lectura y escritura se configuraron para ocultar campos sensibles (por ejemplo, `password`) y para excluir campos calculados o de auditoría (`created_at`, `updated_at`, `due_date`, `fine_amount`, etc.) en los endpoints donde no corresponde que el cliente los envíe.
* Para los préstamos (`Loan`), el campo `due_date` se calcula automáticamente a partir de `loan_dt` (por defecto, 14 días después), y los estados se gestionan mediante el enum `LoanStatus`, lo que simplifica la lógica de préstamos activos, devueltos y vencidos.
* El archivo `initial_data.sql` se generó con `pg_dump -Ox` para que el esquema y los datos iniciales sean fácilmente restaurables sin atar el dump a un usuario u ownership específico.

---

### Uso de herramientas de IA

Durante el desarrollo de este proyecto se utilizaron herramientas de inteligencia artificial como apoyo en:

* La **resolución de problemas de configuración** (por ejemplo, errores de migraciones con Alembic y ajustes en la URL de conexión a PostgreSQL).
* La **validación de reglas de negocio**, como la validación de correos electrónicos y restricciones sobre los datos de entrada en los DTOs.
* La investigación y corrección del error relacionado con el tipo `loan_status_enum` en una migración de Alembic, ajustando la creación explícita del tipo enum antes de agregar la columna correspondiente en la tabla `loans`.

Las herramientas de IA se emplearon como asistencia para depurar, refinar el diseño y revisar el código, pero las decisiones finales de implementación, estructura de modelos y endpoints fueron tomadas manualmente, verificando el comportamiento de la API mediante pruebas en el entorno local.

---

## Tabla de cumplimientos

| Requerimiento                                      | Estado    | Observación |
|----------------------------------------------------|-----------|-------------|
| 1. Modelo Category + relación many-to-many con Book| Cumplido  | -           |
| 2. Modelo Review y CRUD de reseñas                 | Cumplido  | -           |
| 3. Campos extra en Book (stock, descripción, etc.) | Cumplido  | -           |
| 4. Campos extra en User (email, contacto, is_active)| Cumplido | -           |
| 5. Campos extra en Loan + LoanStatus               | Cumplido  | -           |
| 6. Métodos avanzados en BookRepository + endpoints | Cumplido  | -           |
| 7. Métodos avanzados en LoanRepository + endpoints | Cumplido  | -           |
| 8. Base de datos inicial + initial_data.sql        | Cumplido  | -           |
