USE shop_dwh;

CREATE TABLE dim_date AS
SELECT DISTINCT CAST(order_date AS DATE) AS date_key,
                YEAR(order_date)         AS year,
                MONTH(order_date)        AS month,
                DAY(order_date)          AS day,
                WEEKDAY(order_date)      AS day_of_week
FROM stg_orders;

CREATE TABLE dim_product AS
SELECT p.product_id AS product_key,
       p.product_name,
       c.category_name,
       p.price      AS current_price,
       p.stock_quantity,
       p.supplier_id
FROM stg_products p
         LEFT JOIN stg_categories c ON p.category_id = c.category_id;


CREATE TABLE dim_customer AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       c.city,
       c.registration_date,
       c.is_premium
FROM stg_customers AS c;

CREATE TABLE fact_sales AS
SELECT o.order_id                  AS order_key,
       dc.customer_id              AS customer_id,
       dp.product_key              AS product_key,
       dd.date_key                 AS date_key,
       oi.quantity                 AS quantity_sold,
       oi.unit_price * oi.quantity AS line_revenue,
       o.total_amount              AS order_revenue
FROM stg_orders o
         JOIN stg_order_items oi ON o.order_id = oi.order_id
         JOIN dim_customer dc ON o.customer_id = dc.customer_id
         JOIN dim_product dp ON oi.product_id = dp.product_key
         JOIN dim_date dd ON CAST(o.order_date AS DATE) = dd.date_key;
