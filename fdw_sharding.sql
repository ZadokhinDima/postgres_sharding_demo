-- MAIN SERVER
CREATE TABLE book (
                      id SERIAL PRIMARY KEY,
                      title VARCHAR(255),
                      author VARCHAR(255),
                      year INT,
                      category VARCHAR(255)
);

create index book_author_index
    on book (author);

create index book_year_index
    on book (year);

create index book_category_index
    on book (category);

-- SHARD SERVER 1

CREATE TABLE book (
                      id SERIAL PRIMARY KEY,
                      title VARCHAR(255),
                      author VARCHAR(255),
                      year INT,
                      category VARCHAR(255) CONSTRAINT category_check CHECK (category in ('Fiction', 'Non-Fiction', 'Science'))
);

create index book_author_index
    on book (author);

create index book_year_index
    on book (year);

create index book_category_index
    on book (category);

-- SHARD SERVER 2

CREATE TABLE book (
                      id SERIAL PRIMARY KEY,
                      title VARCHAR(255),
                      author VARCHAR(255),
                      year INT,
                      category VARCHAR(255) CONSTRAINT category_check CHECK (category in ('Technology', 'Biography', 'History'))
);

create index book_author_index
    on book (author);

create index book_year_index
    on book (year);

create index book_category_index
    on book (category);

-- MAIN SERVER

CREATE EXTENSION postgres_fdw;

CREATE SERVER books_1_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'postgresql-b1', dbname 'book_1', port '5432');

CREATE USER MAPPING FOR postgres
    SERVER books_1_server
    OPTIONS (user 'postgres', password 'postgres');


CREATE FOREIGN TABLE book_1 (
    id SERIAL not null,
    title VARCHAR(255),
    author VARCHAR(255),
    year INT,
    category VARCHAR(255))
SERVER books_1_server
OPTIONS (schema_name 'public', table_name 'book');

CREATE SERVER books_2_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'postgresql-b2', dbname 'book_2', port '5432');

CREATE USER MAPPING FOR postgres
    SERVER books_2_server
    OPTIONS (user 'postgres', password 'postgres');


CREATE FOREIGN TABLE book_2 (
    id SERIAL not null,
    title VARCHAR(255),
    author VARCHAR(255),
    year INT,
    category VARCHAR(255))
    SERVER books_2_server
    OPTIONS (schema_name 'public', table_name 'book');


CREATE VIEW books AS
    SELECT * FROM book
    UNION ALL
    SELECT * FROM book_1
    UNION ALL
    SELECT * FROM book_2;

CREATE RULE insert_books AS ON INSERT TO books
    DO INSTEAD NOTHING;
CREATE RULE update_books AS ON UPDATE TO books
    DO INSTEAD NOTHING;
CREATE RULE delete_books AS ON DELETE TO books
    DO INSTEAD NOTHING;

CREATE RULE insert_book AS ON INSERT TO books
    WHERE (NEW.category not in ('Fiction', 'Non-Fiction', 'Science', 'Technology', 'Biography', 'History'))
    DO INSTEAD INSERT INTO book (title, author, year, category) VALUES (NEW.title, NEW.author, NEW.year, NEW.category);

CREATE RULE update_book AS ON UPDATE TO books
    WHERE (NEW.category not in ('Fiction', 'Non-Fiction', 'Science', 'Technology', 'Biography', 'History'))
    DO INSTEAD
    UPDATE book
    SET title = NEW.title, author = NEW.author, year = NEW.year, category = NEW.category
    WHERE id = NEW.id;

CREATE RULE delete_book AS ON DELETE TO books
    WHERE (category not in ('Fiction', 'Non-Fiction', 'Science', 'Technology', 'Biography', 'History'))
    DO INSTEAD DELETE FROM book_1 WHERE id = OLD.id;

CREATE RULE insert_book_1 AS ON INSERT TO books
    WHERE (NEW.category in ('Fiction', 'Non-Fiction', 'Science'))
    DO INSTEAD INSERT INTO book_1 (title, author, year, category) VALUES (NEW.title, NEW.author, NEW.year, NEW.category);

CREATE RULE update_book_1 AS ON UPDATE TO books
    WHERE (NEW.category in ('Fiction', 'Non-Fiction', 'Science'))
    DO INSTEAD
    UPDATE book_1
    SET title = NEW.title, author = NEW.author, year = NEW.year, category = NEW.category
    WHERE id = NEW.id;

CREATE RULE delete_book_1 AS ON DELETE TO books
    WHERE (category in ('Fiction', 'Non-Fiction', 'Science'))
    DO INSTEAD DELETE FROM book_1 WHERE id = OLD.id;

CREATE RULE insert_book_2 AS ON INSERT TO books
    WHERE (NEW.category in ('Technology', 'Biography', 'History'))
    DO INSTEAD INSERT INTO book_2 (title, author, year, category) VALUES (NEW.title, NEW.author, NEW.year, NEW.category);

CREATE RULE update_book_2 AS ON UPDATE TO books
    WHERE (NEW.category in ('Technology', 'Biography', 'History'))
    DO INSTEAD
    UPDATE book_2
    SET title = NEW.title, author = NEW.author, year = NEW.year, category = NEW.category
    WHERE id = NEW.id;

CREATE RULE delete_book_2 AS ON DELETE TO books
    WHERE (category in ('Technology', 'Biography', 'History'))
    DO INSTEAD DELETE FROM book_2 WHERE id = OLD.id;