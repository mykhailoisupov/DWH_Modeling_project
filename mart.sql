CREATE TABLE shop_dwh.mart_monthly_category_sales AS
SELECT
    dd.year,
    dd.month,
    dp.category_name,
    SUM(fs.quantity_sold) AS total_quantity_sold,
    SUM(fs.line_revenue) AS total_revenue
FROM shop_dwh.fact_sales AS fs
JOIN shop_dwh.dim_date AS dd
    ON fs.date_key = dd.date_key
JOIN shop_dwh.dim_product AS dp
    ON fs.product_key = dp.product_key
GROUP BY
    dd.year,
    dd.month,
    dp.category_name;

CREATE TABLE shop_dwh.mart_customer_sales_summary AS
SELECT
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    dc.city,
    dc.is_premium,
    COUNT(DISTINCT fs.order_key) AS number_of_orders,
    SUM(fs.line_revenue) AS total_spend
FROM shop_dwh.fact_sales AS fs
JOIN shop_dwh.dim_customer AS dc
    ON fs.customer_id = dc.customer_id
GROUP BY
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    dc.city,
    dc.is_premium;
