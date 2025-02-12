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

ALTER TABLE books
    ADD COLUMN page_count INT;

SELECT *
FROM books
WHERE page_count > (SELECT AVG(page_count) FROM books);

ALTER TABLE books
    ADD COLUMN copies INT,
ADD COLUMN price DECIMAL(10, 2),
ADD COLUMN year_of_publication INT;

SELECT *
FROM books
WHERE year_of_publication = (SELECT MAX(year_of_publication) FROM books);

SELECT *
FROM books AS b1
WHERE (b1.price * b1.copies) > (SELECT SUM(price * copies)
                                FROM books
                                WHERE price * copies > 300000
                                GROUP BY book_title
                                HAVING SUM(price * copies) >= 300000);

SELECT book_id, book_title, year_of_publication, ISBN, price, copies
FROM books
GROUP BY book_title
HAVING (price * copies) > (SELECT SUM(price * copies) FROM books WHERE price * copies > 300000);

WITH cte AS (SELECT book_title, SUM(price * copies) AS total_value
             FROM books
             GROUP BY book_title)
SELECT *
FROM books b
         JOIN cte ON b.book_title = cte.book_title
WHERE (price * copies) > total_value
  AND total_value >= 300000;

WITH cte AS (SELECT book_title, SUM(price * copies) AS total_value
             FROM books
             GROUP BY book_title)
SELECT *
FROM books b
         JOIN cte ON b.book_title = cte.book_title
WHERE (price * copies) > total_value
  AND total_value >= 300000;

SELECT book_title,
       year_of_publication,
       full_name,
       CASE
           WHEN year_of_publication >= (SELECT MAX(year_of_publication) FROM books) THEN 'Новая книга'
           WHEN year_of_publication BETWEEN (SELECT MAX(year_of_publication) - 1 FROM books) AND (SELECT MAX(year_of_publication))
               THEN 'Свежая книга'
           ELSE 'Старая книга'
           END AS book_status
FROM books
         JOIN authors ON books.author_id = authors.author_id;
