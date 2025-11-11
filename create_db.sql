CREATE DATABASE shop_dwh;

USE shop_db;

DROP TABLE IF EXISTS Customers, Categories, Products, Orders, OrderItems;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    registration_date DATE,
    is_premium BOOLEAN
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    supplier_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE Customers;
TRUNCATE Categories;
TRUNCATE Products;
TRUNCATE Orders;
TRUNCATE OrderItems;

SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Categories;
SELECT COUNT(*) FROM Orders;
SELECT COUNT(*) FROM OrderItems;

