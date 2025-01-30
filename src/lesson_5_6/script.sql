CREATE TABLE books
(
    book_id             INT PRIMARY KEY AUTO_INCREMENT,
    book_title          VARCHAR(255),
    year_of_publication INT,
    ISBN                VARCHAR(13)
);

CREATE TABLE authors
(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255)
);

CREATE TABLE publishing_houses
(
    publishing_id INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(255)
);

CREATE TABLE books_authors
(
    id_author_book INT PRIMARY KEY AUTO_INCREMENT,
    id_book        INT,
    id_author      INT,
    FOREIGN KEY (id_book) REFERENCES books (book_id),
    FOREIGN KEY (id_author) REFERENCES authors (author_id)
);

INSERT INTO books (book_title, year_of_publication, ISBN)
VALUES ('Война и мир', 1869, '0-00-000001'),
       ('Преступление и наказание', 1866, '0-00-000002');

INSERT INTO authors (full_name)
VALUES ('Лев Николаевич Толстой'),
       ('Фёдор Михайлович Достоевский');

INSERT INTO publishing_houses (name)
VALUES ('Эксмо'),
       ('Азбука');

INSERT INTO books_authors (id_book, id_author)
VALUES (1, 1),
       (2, 1);

SELECT *
FROM books
         JOIN publishing_houses ON books.book_id = publishing_houses.id_book;
