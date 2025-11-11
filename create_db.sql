CREATE DATABASE shop_dwh;

USE shop_dwh;

CREATE TABLE raw_customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    registration_date DATE,
    is_premium BOOLEAN
);

CREATE TABLE raw_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50)
);

CREATE TABLE raw_products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    supplier_id INT,
    FOREIGN KEY (category_id) REFERENCES raw_categories(category_id)
);

CREATE TABLE raw_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES raw_customers(customer_id)
);

CREATE TABLE raw_order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES raw_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES raw_products(product_id)
);