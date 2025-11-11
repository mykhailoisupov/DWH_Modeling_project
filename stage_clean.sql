USE shop_dwh;

CREATE TABLE stg_customers AS
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    LOWER(TRIM(email)) AS email,
    TRIM(city) AS city,
    CAST(registration_date AS DATE) AS registration_date,
    is_premium
FROM raw_customers
WHERE email IS NOT NULL;

CREATE TABLE stg_categories AS
SELECT
    category_id,
    TRIM(category_name) AS category_name
FROM raw_categories;

CREATE TABLE stg_products AS
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    category_id,
    price,
    stock_quantity,
    supplier_id
FROM raw_products
WHERE price > 0 AND stock_quantity >= 0;

CREATE TABLE stg_orders AS
SELECT
    order_id,
    customer_id,
    CAST(order_date AS DATETIME) AS order_date,
    total_amount,
    TRIM(status) AS status
FROM raw_orders
WHERE total_amount >= 0;

CREATE TABLE stg_order_items AS
SELECT
    item_id,
    order_id,
    product_id,
    quantity,
    unit_price
FROM raw_order_items
WHERE quantity > 0 AND unit_price > 0;