/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
CREATE OR REPLACE VIEW gold.report_products AS
WITH product_base_query AS (
SELECT p.product_id,
		p.product_name,
		p.product_category,
		p.product_subcategory,
		p.product_cost,
		s.customer_key,
		s.sls_ord_num,
		s.product_key,
		s.sls_order_dt,		
		s.sls_quantity,
		s.sls_price AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE s.sls_order_dt IS NOT NULL),

aggregate_products AS (
SELECT product_name,
		product_category,
		product_subcategory,
		COUNT(DISTINCT sls_ord_num) AS total_orders,
		SUM(sales_amount) AS total_sales,
        SUM(sls_quantity) AS total_quantity_sold,
		COUNT(DISTINCT customer_key) AS total_customers,
		(EXTRACT(YEAR FROM AGE(MAX(sls_order_dt),MIN(sls_order_dt)))*12) + 
		EXTRACT(MONTH FROM AGE(MAX(sls_order_dt),MIN(sls_order_dt))) AS life_span,
		MAX(sls_order_dt) last_order_date
FROM product_base_query
GROUP BY product_name,product_category,product_subcategory)

SELECT product_name,
		product_category,
		product_subcategory,
		total_orders,
		total_sales,
		CASE WHEN total_sales > 999999 THEN 'High-Performers' 
			 WHEN total_sales BETWEEN 50000 AND 999999 THEN 'Mid-Range'
			 ELSE 'Low-Performers' END AS product_segment,
        total_quantity_sold,
		total_customers,
		life_span,
		last_order_date,
		(EXTRACT(YEAR FROM AGE(CURRENT_DATE,last_order_date))*12) + 
		EXTRACT(MONTH FROM AGE(CURRENT_DATE,last_order_date)) AS recency,		
		CASE WHEN total_quantity_sold = 0 THEN 0
			 ELSE (total_sales/total_quantity_sold) END AS average_order_value,
		CASE WHEN life_span = 0 THEN 0 -- There are zeros, you can modify(in place of 0) those into total_sales
			 ELSE ROUND((total_sales/life_span),2) END AS average_monthly_spend
FROM aggregate_products;

DROP VIEW gold.report_products;

SELECT * FROM gold.report_products;