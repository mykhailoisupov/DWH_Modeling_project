CREATE TABLE shop_dwh.dim_date AS
SELECT DISTINCT
    CAST(order_date AS DATE) AS date_key,
    EXTRACT(YEAR FROM CAST(order_date AS DATE)) AS year,
    EXTRACT(MONTH FROM CAST(order_date AS DATE)) AS month,
    EXTRACT(DAY FROM CAST(order_date AS DATE)) AS day,
    EXTRACT(DAYOFWEEK FROM CAST(order_date AS DATE)) AS day_of_week -- Note: 1=Sunday, 7=Saturday
FROM shop_dwh.stg_orders;

CREATE TABLE shop_dwh.dim_product AS
SELECT
    p.product_id AS product_key,
    p.product_name,
    c.category_name,
    p.price AS current_price,
    p.stock_quantity,
    p.supplier_id
FROM shop_dwh.stg_products AS p
LEFT JOIN shop_dwh.stg_categories AS c
    ON p.category_id = c.category_id;

CREATE TABLE shop_dwh.dim_customer AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date,
    c.is_premium
FROM shop_dwh.stg_customers AS c;

CREATE TABLE shop_dwh.fact_sales AS
SELECT
    o.order_id AS order_key,
    dc.customer_id AS customer_id,
    dp.product_key AS product_key,
    dd.date_key AS date_key,
    oi.quantity AS quantity_sold,
    oi.unit_price * oi.quantity AS line_revenue,
    o.total_amount AS order_revenue
FROM shop_dwh.stg_orders AS o
JOIN shop_dwh.stg_order_items AS oi
    ON o.order_id = oi.order_id
JOIN shop_dwh.dim_customer AS dc
    ON o.customer_id = dc.customer_id
JOIN shop_dwh.dim_product AS dp
    ON oi.product_id = dp.product_key
JOIN shop_dwh.dim_date AS dd
    ON CAST(o.order_date AS DATE) = dd.date_key;
