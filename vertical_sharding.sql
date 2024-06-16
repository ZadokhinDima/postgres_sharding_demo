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

CREATE TABLE book_1 (
    check (category in ('Fiction', 'Non-Fiction', 'Science'))
) INHERITS (book);

create index book1_author_index
    on book_1 (author);

create index book1_year_index
    on book_1 (year);

create index book1_category_index
    on book_1 (category);

CREATE RULE insert_book_1 AS ON INSERT TO book
    WHERE (category in ('Fiction', 'Non-Fiction', 'Science'))
    DO INSTEAD INSERT INTO book_1 VALUES (NEW.*);

CREATE RULE update_book_1 AS ON UPDATE TO book
    WHERE (category in ('Fiction', 'Non-Fiction', 'Science'))
DO INSTEAD
    UPDATE book_1
        SET title = NEW.title, author = NEW.author, year = NEW.year, category = NEW.category
        WHERE id = NEW.id;

CREATE RULE delete_book_1 AS ON DELETE TO book
    WHERE (category in ('Fiction', 'Non-Fiction', 'Science'))
    DO INSTEAD DELETE FROM book_1 WHERE id = OLD.id;

CREATE TABLE book_2 (
    check (category in ('Technology', 'Biography', 'History'))
) INHERITS (book);


create index book2_author_index
    on book_2 (author);

create index book2_year_index
    on book_2 (year);

create index book2_category_index
    on book_2 (category);


CREATE RULE insert_book_2 AS ON INSERT TO book
    WHERE (category in ('Technology', 'Biography', 'History'))
    DO INSTEAD INSERT INTO book_2 VALUES (NEW.*);

CREATE RULE update_book_2 AS ON UPDATE TO book
    WHERE (category in ('Technology', 'Biography', 'History'))
    DO INSTEAD
    UPDATE book_2
    SET title = NEW.title, author = NEW.author, year = NEW.year, category = NEW.category
    WHERE id = NEW.id;

CREATE RULE delete_book_2 AS ON DELETE TO book
    WHERE (category in ('Technology', 'Biography', 'History'))
    DO INSTEAD DELETE FROM book_2 WHERE id = OLD.id;