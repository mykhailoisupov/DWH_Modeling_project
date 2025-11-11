USE shop_dwh;

CREATE TABLE mart_monthly_category_sales AS
SELECT dd.year,
       dd.month,
       dp.category_name,
       SUM(fs.quantity_sold) AS total_quantity_sold,
       SUM(fs.line_revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_date dd ON fs.date_key = dd.date_key
JOIN dim_product dp ON fs.product_key = dp.product_key
GROUP BY dd.year, dd.month, dp.category_name;

CREATE TABLE mart_customer_sales_summary AS
SELECT dc.customer_id,
       dc.first_name,
       dc.last_name,
       dc.city,
       dc.is_premium,
       COUNT(DISTINCT fs.order_key) AS number_of_orders,
       SUM(fs.line_revenue) AS total_spend
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_id = dc.customer_id
GROUP BY dc.customer_id, dc.first_name, dc.last_name, dc.city, dc.is_premium;