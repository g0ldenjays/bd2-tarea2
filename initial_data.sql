--
-- PostgreSQL database dump
--

\restrict COP7O7wgz8mWzk447SI7DmJaRDocaXeduTvwlQ8m6MT7tK39MAveK6X1ueVaSey

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: loan_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loan_status_enum AS ENUM (
    'ACTIVE',
    'RETURNED',
    'OVERDUE'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: book_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_categories (
    book_id bigint NOT NULL,
    category_id bigint NOT NULL
);


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    id bigint NOT NULL,
    title character varying NOT NULL,
    author character varying NOT NULL,
    isbn character varying NOT NULL,
    pages integer NOT NULL,
    published_year integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    stock integer DEFAULT 1 NOT NULL,
    description character varying,
    language character varying DEFAULT 'en'::character varying NOT NULL,
    publisher character varying
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loans (
    id bigint NOT NULL,
    loan_dt date NOT NULL,
    return_dt date,
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    due_date date DEFAULT CURRENT_DATE NOT NULL,
    fine_amount numeric(10,2),
    status public.loan_status_enum DEFAULT 'ACTIVE'::public.loan_status_enum NOT NULL
);


--
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.loans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    rating integer NOT NULL,
    comment character varying NOT NULL,
    review_date date NOT NULL,
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying NOT NULL,
    fullname character varying NOT NULL,
    password character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    email character varying,
    phone character varying,
    address character varying,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
e293bdce5822
\.


--
-- Data for Name: book_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.book_categories (book_id, category_id) FROM stdin;
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.books (id, title, author, isbn, pages, published_year, created_at, updated_at, stock, description, language, publisher) FROM stdin;
1	La ciudad de los espejos	María Pérez	ISBN-BD2-2025-0001	320	2018	2025-12-04 16:49:26.410999-03	2025-12-04 16:49:26.411001-03	3	Novela de ficción contemporánea sobre una ciudad donde los recuerdos toman forma física.	es	Editorial Aurora
2	Sombras en el andén	Carlos Díaz	ISBN-BD2-2025-0002	210	2020	2025-12-04 16:49:41.485833-03	2025-12-04 16:49:41.485837-03	5	Relato de ficción sobre encuentros extraños en una estación de tren nocturna.	es	Luz de Invierno
3	Hábitos atómicos financieros	Laura González	ISBN-BD2-2025-0003	260	2021	2025-12-04 16:49:48.728675-03	2025-12-04 16:49:48.728678-03	4	Guía de no ficción sobre cómo mejorar las finanzas personales a través de pequeños hábitos diarios.	es	Editorial Horizonte
4	El arte de aprender idiomas	Andrés Rivas	ISBN-BD2-2025-0004	190	2019	2025-12-04 16:50:00.769816-03	2025-12-04 16:50:00.769819-03	2	Libro de no ficción que explora estrategias prácticas para dominar nuevas lenguas.	es	Mundo Abierto
5	Introducción visual a la física moderna	Elena Martínez	ISBN-BD2-2025-0005	280	2017	2025-12-04 16:50:16.272389-03	2025-12-04 16:50:16.272392-03	6	Libro de divulgación científica que explica conceptos de relatividad y mecánica cuántica con ejemplos simples.	es	Ciencia Viva
6	Biología de los ecosistemas urbanos	Javier Soto	ISBN-BD2-2025-0006	340	2022	2025-12-04 16:50:24.761925-03	2025-12-04 16:50:24.761929-03	3	Estudio científico sobre la interacción entre flora, fauna y seres humanos en ciudades modernas.	es	EcoLibros
7	Crónicas del Imperio del Sur	Paula Herrera	ISBN-BD2-2025-0007	410	2015	2025-12-04 16:50:32.43925-03	2025-12-04 16:50:32.439255-03	5	Relato histórico novelado sobre el auge y caída de un imperio ficticio inspirado en América Latina.	es	Memoria Histórica
8	La ruta de las revoluciones	Ricardo Fuentes	ISBN-BD2-2025-0008	360	2013	2025-12-04 16:50:41.719651-03	2025-12-04 16:50:41.719657-03	2	Ensayo histórico que recorre las principales revoluciones políticas de los últimos tres siglos.	es	Siglo XXI Ediciones
9	El bosque de las cuatro lunas	Isabel Correa	ISBN-BD2-2025-0009	380	2020	2025-12-04 16:50:52.328127-03	2025-12-04 16:50:52.32813-03	7	Novela de fantasía sobre una joven guardiana que protege un bosque mágico de una antigua amenaza.	es	Reino de Papel
10	El dragón de las tormentas eternas	Tomás Aguilar	ISBN-BD2-2025-0010	450	2016	2025-12-04 16:51:07.840934-03	2025-12-04 16:51:07.840937-03	4	Aventura de fantasía épica donde un grupo de héroes busca despertar a un dragón ancestral para salvar su mundo.	es	Niebla Azul
11	El caso del reloj silencioso	Lucía Navarro	ISBN-BD2-2025-0011	295	2018	2025-12-04 16:51:13.819828-03	2025-12-04 16:51:13.819831-03	3	Novela de crimen en la que una detective investiga un asesinato ocurrido durante un apagón general.	es	Sombra Negra
12	Cicatrices en la nieve	Diego Arancibia	ISBN-BD2-2025-0012	330	2021	2025-12-04 16:51:19.500713-03	2025-12-04 16:51:19.500717-03	2	Thriller policial ambientado en un pueblo aislado donde todos ocultan un secreto.	es	Crimen & Misterio
13	Programación en Python para humanos ocupados	Alejandro Torres	ISBN-BD2-2025-0013	270	2023	2025-12-04 16:51:25.654643-03	2025-12-04 16:51:25.654646-03	8	Introducción práctica a Python enfocada en ejemplos simples y proyectos pequeños.	es	Código Claro
14	Arquitectura de APIs modernas	Natalia Rojas	ISBN-BD2-2025-0014	310	2022	2025-12-04 16:51:40.785909-03	2025-12-04 16:51:40.785915-03	5	Guía sobre diseño y buenas prácticas para construir APIs REST y aplicaciones backend escalables.	es	Bit & Byte
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, description, created_at, updated_at) FROM stdin;
1	Ficción	Libros basados en historias imaginarias, narrativas inventadas y personajes creados por el autor.	2025-12-04 16:42:55.75801-03	2025-12-04 16:42:55.758014-03
2	No Ficción	Libros basados en hechos reales, biografías, ensayos, divulgación y contenido informativo.	2025-12-04 16:44:34.400387-03	2025-12-04 16:44:34.400402-03
3	Ciencia	Libros relacionados con física, biología, química, astronomía y otras disciplinas científicas.	2025-12-04 16:44:41.499293-03	2025-12-04 16:44:41.499296-03
4	Historia	Libros sobre eventos históricos, civilizaciones, guerras, procesos sociales y personajes del pasado.	2025-12-04 16:44:47.513797-03	2025-12-04 16:44:47.513803-03
5	Fantasía	Libros con magia, mundos imaginarios, criaturas fantásticas y elementos sobrenaturales.	2025-12-04 16:44:53.262272-03	2025-12-04 16:44:53.26228-03
6	Crímen	Libros de misterio, investigación policial, novelas negras y tramas centradas en delitos.	2025-12-04 16:45:04.411649-03	2025-12-04 16:45:04.411653-03
7	Computación	Libros sobre programación, sistemas, inteligencia artificial, redes y tecnología en general.	2025-12-04 16:45:12.6673-03	2025-12-04 16:45:12.667305-03
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.loans (id, loan_dt, return_dt, user_id, book_id, created_at, updated_at, due_date, fine_amount, status) FROM stdin;
1	2025-11-10	\N	1	3	2025-12-04 17:01:09.31112-03	2025-12-04 17:01:09.311124-03	2025-11-24	\N	ACTIVE
2	2025-11-15	\N	2	5	2025-12-04 17:01:14.482067-03	2025-12-04 17:01:14.482071-03	2025-11-29	\N	ACTIVE
3	2025-12-01	\N	3	7	2025-12-04 17:01:19.503661-03	2025-12-04 17:01:19.503665-03	2025-12-15	\N	ACTIVE
4	2025-12-03	\N	4	9	2025-12-04 17:01:25.351718-03	2025-12-04 17:01:25.351722-03	2025-12-17	\N	ACTIVE
5	2025-11-20	2025-11-30	5	11	2025-12-04 17:01:37.85561-03	2025-12-04 17:02:37.14252-03	2025-12-04	\N	RETURNED
6	2025-11-05	2025-11-25	2	2	2025-12-04 17:01:51.106922-03	2025-12-04 17:02:44.731945-03	2025-11-19	\N	RETURNED
7	2025-10-25	2025-11-20	3	4	2025-12-04 17:01:56.484828-03	2025-12-04 17:02:58.462754-03	2025-11-08	\N	RETURNED
8	2025-11-20	2025-12-04	1	14	2025-12-04 17:02:02.15212-03	2025-12-04 17:03:02.647199-03	2025-12-04	\N	RETURNED
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reviews (id, rating, comment, review_date, user_id, book_id, created_at, updated_at) FROM stdin;
1	5	Me encantó la historia, muy original y atrapante de principio a fin.	2025-12-03	1	1	2025-12-04 17:05:44.340124-03	2025-12-04 17:05:44.340128-03
2	4	Muy buena fantasía, el mundo está bien construido, aunque el inicio es algo lento.	2025-12-04	2	9	2025-12-04 17:05:50.326404-03	2025-12-04 17:05:50.326408-03
3	5	Excelente para comenzar con Python, ejemplos claros y fáciles de seguir.	2025-12-04	3	13	2025-12-04 17:06:04.148872-03	2025-12-04 17:06:04.148876-03
4	4	Muy interesante y bien explicado, ideal para entender mejor las finanzas personales.	2025-12-04	1	3	2025-12-04 17:07:35.556561-03	2025-12-04 17:07:35.556567-03
5	5	Una fantasía épica que me tuvo pegado al libro, el final fue increíble.	2025-12-05	1	10	2025-12-04 17:07:40.608969-03	2025-12-04 17:07:40.608973-03
6	3	La historia es buena, pero sentí que algunos capítulos se alargan demasiado.	2025-12-04	2	2	2025-12-04 17:07:45.366216-03	2025-12-04 17:07:45.36622-03
7	5	Excelente novela de crimen, el giro final fue totalmente inesperado.	2025-12-05	2	11	2025-12-04 17:07:50.201505-03	2025-12-04 17:07:50.201509-03
8	4	Buena introducción a la física moderna, aunque algunos conceptos son densos.	2025-12-03	3	5	2025-12-04 17:07:56.484757-03	2025-12-04 17:07:56.484761-03
9	5	Me ayudó muchísimo a mejorar mi forma de estudiar idiomas, muy recomendado.	2025-12-06	3	4	2025-12-04 17:08:01.449398-03	2025-12-04 17:08:01.449403-03
10	5	Perfecto para quienes programan backend, me sentí muy identificado con los ejemplos.	2025-12-04	4	13	2025-12-04 17:08:06.885995-03	2025-12-04 17:08:06.886002-03
11	4	La forma de mezclar historia con narrativa me pareció muy entretenida.	2025-12-05	4	7	2025-12-04 17:08:11.877434-03	2025-12-04 17:08:11.877438-03
12	3	Interesante, pero algo técnico para alguien que no viene del área científica.	2025-12-06	4	6	2025-12-04 17:08:17.325422-03	2025-12-04 17:08:17.325426-03
13	4	Buen repaso de distintos procesos históricos, aprendí varios datos nuevos.	2025-12-03	5	8	2025-12-04 17:08:24.221825-03	2025-12-04 17:08:24.22183-03
14	5	Un thriller muy tenso, lo leí casi de una sentada.	2025-12-04	5	12	2025-12-04 17:08:30.035181-03	2025-12-04 17:08:30.035185-03
15	5	Excelente referencia para diseño de APIs modernas, muy útil para proyectos profesionales.	2025-12-05	5	14	2025-12-04 17:08:36.150651-03	2025-12-04 17:08:36.150656-03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, fullname, password, created_at, updated_at, email, phone, address, is_active) FROM stdin;
1	lector.clasicos	Manuel Rodríguez	$argon2id$v=19$m=65536,t=3,p=4$9F8pN1wPKemrP2jtyr32yQ$6ej2zwynYlLoHz/tF01/KmD4GwcgBbWFbjFVuNWOHPQ	2025-12-04 16:53:44.911162-03	2025-12-04 16:53:44.911166-03	lector.clasicos@example.com	+56 9 1111 1111	Av. Independencia 1234, Punta Arenas	t
2	fan.fantasia	Camila Fernández	$argon2id$v=19$m=65536,t=3,p=4$ENbwM06U1Ffi7rRRfp3yMQ$atE+mW7cE/N8SLZ6jqgMNxDwrryZfKuLgIyXDaqTW04	2025-12-04 16:53:58.101303-03	2025-12-04 16:53:58.101309-03	fan.fantasia@example.com	+56 9 2222 2222	Pasaje Luna 456, Punta Arenas	t
3	historiador.aficionado	Jorge Alarcón	$argon2id$v=19$m=65536,t=3,p=4$dlGlC1mRDl9zLVfWYwHhbQ$8GbhzWu8qCKh0eAIl8/XXLRY451uGDIOxhQPJsWsS1Q	2025-12-04 16:54:04.539179-03	2025-12-04 16:54:04.539183-03	historia.aficionado@example.com	+56 9 3333 3333	Calle Museo 789, Punta Arenas	t
4	dev.backend	Valentina Ruiz	$argon2id$v=19$m=65536,t=3,p=4$qeuZUqr1HcUBQT2fvMemmA$W2j8YFLgtGXnKP7vbLUDICrgxVZqG8ibEzExSz6m+a8	2025-12-04 16:54:10.714596-03	2025-12-04 16:54:10.714599-03	dev.backend@example.com	+56 9 4444 4444	Condominio Servicios 321, Punta Arenas	t
5	misterios.nocturnos	Sebastián Contreras	$argon2id$v=19$m=65536,t=3,p=4$+gjJ22vgzOva3PYfScDJmQ$LB5LlgJCqaERTtmB6S8mAym35SgIf3Cjtkx2n9X/Uow	2025-12-04 16:54:16.214663-03	2025-12-04 16:54:16.214667-03	misterios.nocturnos@example.com	+56 9 5555 5555	Pasaje Sombra 654, Punta Arenas	t
\.


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.books_id_seq', 14, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 7, true);


--
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.loans_id_seq', 8, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reviews_id_seq', 15, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: book_categories pk_book_categories; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT pk_book_categories PRIMARY KEY (book_id, category_id);


--
-- Name: books pk_books; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT pk_books PRIMARY KEY (id);


--
-- Name: categories pk_categories; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT pk_categories PRIMARY KEY (id);


--
-- Name: loans pk_loans; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT pk_loans PRIMARY KEY (id);


--
-- Name: reviews pk_reviews; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT pk_reviews PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: books uq_books_isbn; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT uq_books_isbn UNIQUE (isbn);


--
-- Name: books uq_books_title; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT uq_books_title UNIQUE (title);


--
-- Name: categories uq_categories_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT uq_categories_name UNIQUE (name);


--
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: users uq_users_username; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_username UNIQUE (username);


--
-- Name: book_categories fk_book_categories_book_id_books; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_categories_book_id_books FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: book_categories fk_book_categories_category_id_categories; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_categories_category_id_categories FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: loans fk_loans_book_id_books; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loans_book_id_books FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: loans fk_loans_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loans_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: reviews fk_reviews_book_id_books; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_book_id_books FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: reviews fk_reviews_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict COP7O7wgz8mWzk447SI7DmJaRDocaXeduTvwlQ8m6MT7tK39MAveK6X1ueVaSey

