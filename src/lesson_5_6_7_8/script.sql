CREATE TABLE books
(
    book_id             INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    book_title          VARCHAR(255),
    year_of_publication INT,
    ISBN                VARCHAR(13)
);

ALTER TABLE books
    ADD COLUMN price DECIMAL(10, 2);

CREATE TABLE authors
(
    author_id INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255)
);

CREATE TABLE publishing_houses
(
    publishing_id INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(255)
);

CREATE TABLE books_authors
(
    id_book   INT,
    id_author INT,
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

INSERT INTO books (book_title, year_of_publication, ISBN, price)
VALUES ('Война и мир', 1869, '0-00-000001', 500),
       ('Преступление и наказание', 1866, '0-00-000002', 300);

UPDATE books
SET price = 400
WHERE book_title = 'Война и мир';

SELECT AVG(price) AS average_price,
       MIN(price) AS minimum_price,
       MAX(price) AS maximum_price
FROM books;

SELECT *
FROM books
         JOIN publishing_houses ON books.book_id = publishing_houses.id_book;

SELECT authors.full_name, COUNT(*) AS book_count
FROM authors
         JOIN books_authors ON authors.author_id = books_authors.id_author
GROUP BY authors.full_name;

SELECT authors.full_name,
       COUNT(books.book_id) AS book_count,
       AVG(books.price)     AS average_price
FROM authors
         JOIN books_authors ON authors.author_id = books_authors.id_author
         JOIN books ON books_authors.id_book = books.book_id
GROUP BY authors.full_name;

INSERT INTO authors (full_name)
VALUES ('Иван Иванович Иванов'),
       ('Пётр Петрович Петров');

SELECT *
FROM authors
WHERE NOT EXISTS (SELECT 1 FROM books_authors WHERE authors.author_id = books_authors.id_author)
   OR NOT EXISTS (SELECT 1 FROM books WHERE books_authors.id_book = books.book_id);
