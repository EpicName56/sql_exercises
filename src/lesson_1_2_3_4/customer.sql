CREATE TABLE customer
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    type VARCHAR(255),
    city VARCHAR(255)
);

INSERT INTO customer (name, type, city)
VALUES ('Сергей', 'Новый покупатель', 'Ленинград'),
       ('Петя', 'Постоянный покупатель', 'Орск'),
       ('Вася', 'Постоянный покупатель', 'Ленинград'),
       ('Денис', 'VIP-покупатель', 'Ижевск');

UPDATE customer
SET name = 'Андрей'
WHERE id = 1;

UPDATE customer
SET city = 'Санкт-Петербург'
WHERE city = 'Ленинград'

DELETE
FROM customer
WHERE id = 4;

SELECT *
FROM customer;

SELECT *
FROM customer
WHERE city = 'Санкт-Петербург'
ORDER BY name;