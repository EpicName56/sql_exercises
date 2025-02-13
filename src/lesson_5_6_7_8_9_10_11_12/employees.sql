CREATE TABLE employees
(
    employee_id INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255),
    parent_id   INT,
    FOREIGN KEY (parent_id) REFERENCES employees (employee_id)
);

INSERT INTO employees (name, parent_id)
VALUES ('Иван', NULL);
INSERT INTO employees (name, parent_id)
VALUES ('Евгений', 1);
INSERT INTO employees (name, parent_id)
VALUES ('Анна', 1);

CREATE TABLE categories
(
    category_id INT ALWAYS GENERATED AS IDENTITY PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255),
    parent_id   INT,
    FOREIGN KEY (parent_id) REFERENCES categories (category_id)
);
