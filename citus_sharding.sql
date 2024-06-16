-- All nodes:

CREATE EXTENSION IF NOT EXISTS citus;

-- MAIN SERVER:

CREATE TABLE book (
                      id SERIAL,
                      title VARCHAR(255),
                      author VARCHAR(255),
                      year INT,
                      category VARCHAR(255),
                      PRIMARY KEY (id, category)
);

create index book_author_index
    on book (author);

create index book_year_index
    on book (year);

create index book_category_index
    on book (category);

SELECT * FROM master_add_node('worker-1', 5432);
SELECT * FROM master_add_node('worker-2', 5432);

SELECT * FROM create_distributed_table('book', 'category');
