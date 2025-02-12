CREATE TABLE Stock
(
    warehouse_id INT,
    detail_id    INT,
    quantity     INT CHECK (quantity > 0),
    detail_name  VARCHAR(255),
    FOREIGN KEY (detail_id) REFERENCES Parts (detail_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse (warehouse_id)
);

CREATE TABLE Engineers
(
    engineer_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    engineer_name VARCHAR(255),
    parent_id     INT,
    FOREIGN KEY (parent_id) REFERENCES employees (engineer_id)
);

CREATE TABLE Orders
(
    order_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    order_date    DATE,
    order_status  VARCHAR(20) CHECK (order_status IN ('ожидает', 'в процессе', 'выполнено')),
    detail_id     INT,
    detail_name   VARCHAR(255),
    total_price   DECIMAL(10, 2),
    engineer_name VARCHAR(255),
    FOREIGN KEY (detail_id) REFERENCES Parts (detail_id),
    FOREIGN KEY (engineer_name) REFERENCES Engineers (engineer_name)
);

CREATE TABLE Availability
(
    detail_id    INT,
    quantity     INT CHECK (quantity > 0),
    is_available BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (detail_id) REFERENCES Parts (detail_id)
);

INSERT INTO Stock (warehouse_id, detail_id, quantity, detail_name)
VALUES (1, 1, 5, 'Деталь №1'),
       (1, 2, 3, 'Деталь №2'),
       (1, 3, 7, 'Деталь №3');


INSERT INTO Engineers (engineer_name, parent_id)
VALUES ('Олег Петров', NULL),
       ('Семен Иванов', 1),
       ('Василий Васильев', 1);

ALTER TABLE Stock
    ADD CONSTRAINT check_stock_availability CHECK (
        (SELECT quantity
         FROM Availability
         WHERE detail_id = Stock.detail_id
           AND is_available = TRUE) >= Stock.quantity
        );

SELECT Parts.detail_name,
       SUM(Stock.quantity) AS total_quantity
FROM Stock
         JOIN
     Parts ON Stock.detail_id = Parts.detail_id
GROUP BY Parts.detail_name
ORDER BY total_quantity DESC;

SELECT Orders.order_date,
       COUNT(*)                AS order_count,
       AVG(Orders.total_price) AS average_price
FROM Orders
         JOIN
     Parts ON Orders.detail_id = Parts.detail_id
WHERE (Orders.order_status = 'ожидает' OR Orders.order_status = 'в процессе')
GROUP BY Orders.order_date
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

SELECT Availability.possibility_of_ordering,
       Parts.detail_name,
       MAX(Availability.detail_id) AS max_detail_id
FROM Availability
         JOIN
     Parts ON Availability.detail_id = Parts.detail_id
GROUP BY Possibility_of_ordering, Parts.detail_name
ORDER BY max_detail_id;

INSERT INTO Orders (order_date, order_status, detail_id, detail_name, engineer_name, total_price)
VALUES (CURRENT_DATE(), 'ожидает', 1, 'Деталь №1', 'Олег Петров', 100.50);
