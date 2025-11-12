-- 1. Create the dataset (equivalent to MySQL's DATABASE)
CREATE SCHEMA shop_dwh;

-- 2. Create the tables within the dataset

CREATE TABLE shop_dwh.raw_customers (
    customer_id INT64,
    first_name STRING,
    last_name STRING,
    email STRING,
    city STRING,
    registration_date DATE,
    is_premium BOOL
);

CREATE TABLE shop_dwh.raw_categories (
    category_id INT64,
    category_name STRING
);

CREATE TABLE shop_dwh.raw_products (
    product_id INT64,
    product_name STRING,
    category_id INT64,
    price NUMERIC,
    stock_quantity INT64,
    supplier_id INT64
);

CREATE TABLE shop_dwh.raw_orders (
    order_id INT64,
    customer_id INT64,
    order_date DATETIME,
    total_amount NUMERIC,
    status STRING
);

CREATE TABLE shop_dwh.raw_order_items (
    item_id INT64,
    order_id INT64,
    product_id INT64,
    quantity INT64,
    unit_price NUMERIC
);
