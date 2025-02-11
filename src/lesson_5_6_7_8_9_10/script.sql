CREATE TABLE books
(
    book_id             INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    book_title          VARCHAR(255),
    year_of_publication INT,
    ISBN                VARCHAR(13),
    price               DECIMAL(10, 2)
);

ALTER TABLE books
    ADD CONSTRAINT PK_books PRIMARY KEY (book_id);

CREATE TABLE authors
(
    author_id INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255)
);

ALTER TABLE authors
    ADD CONSTRAINT PK_authors PRIMARY KEY (author_id);

CREATE TABLE publishing_houses
(
    publishing_id INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(255)
);

ALTER TABLE publishing_houses
    ADD CONSTRAINT PK_publishing_houses PRIMARY KEY (publishing_id);

CREATE TABLE books_authors
(
    id_book   INT,
    id_author INT,
    FOREIGN KEY (id_book) REFERENCES books (book_id),
    FOREIGN KEY (id_author) REFERENCES authors (author_id)
);

INSERT INTO books (book_title, year_of_publication, ISBN, price)
VALUES ('Война и мир', 1869, '0-00-000001', 500),
       ('Преступление и наказание', 1866, '0-00-000002', 300);

UPDATE books
SET price = 400
WHERE book_title = 'Война и мир';

SELECT AVG(price) AS average_price, MIN(price) AS minimum_price, MAX(price) AS maximum_price
FROM books;

SELECT *
FROM books
         JOIN publishing_houses ON books.book_id = publishing_houses.id_book;

SELECT authors.full_name, COUNT(*) AS book_count
FROM authors
         JOIN books_authors ON authors.author_id = books_authors.id_author
GROUP BY authors.full_name;

SELECT authors.full_name, COUNT(books.book_id) AS book_count, AVG(books.price) AS average_price
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
