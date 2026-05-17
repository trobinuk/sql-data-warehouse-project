/*Segment products into cost ranges and 
count how many products fall into each segment*/

SELECT *
FROM gold.dim_products;

SELECT DISTINCT product_cost
FROM gold.dim_products
ORDER BY product_cost;

WITH products_cost_cat AS (
SELECT CASE WHEN p.product_cost < 100 THEN 'Low_cost'
			WHEN p.product_cost >= 100 AND p.product_cost < 1000 THEN 'Medium_cost'
		ELSE 'High_cost' END cost_category,
		p.product_id
FROM gold.dim_products p)
SELECT COUNT(product_id) cost_ctg_cnt,
		cost_category
FROM products_cost_cat
GROUP BY cost_category;

WITH product_cost_segments AS (
SELECT CASE WHEN p.product_cost < 100 THEN 'Below 100'
			WHEN p.product_cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN p.product_cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000' END cost_range,
		p.product_id
FROM gold.dim_products p)
SELECT  cost_range,
		COUNT(product_id) total_products
FROM product_cost_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Group Customers into three segments based on their spending behaviour:
	- VIP: Customers with at least 12 months of history and spending more than $5000.
	- Regular: Customers with at least 12 months of history but spending $5000 or less
	- New: Customers with life span less than 12 months.
And, find the total number of customers by each group */

SELECT CURRENT_DATE,
		CURRENT_DATE-c.customer_create_date AS diff,
		AGE(CURRENT_DATE,c.customer_create_date) AS dif_age,
		c.customer_id,
		SUM(s.sls_price) OVER (PARTITION BY s.customer_key) total_sales
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key;

WITH sales_by_customer AS (
select c.customer_id,
		s.customer_key,
		c.customer_firstname,
		c.customer_lastname,
		SUM(s.sls_price) total_sales
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
GROUP BY c.customer_id,s.customer_key,c.customer_firstname,c.customer_lastname),
cust_category AS (
SELECT 
	   s.customer_key,
	   s.customer_firstname,
	   s.customer_lastname,
	   CURRENT_DATE-c.customer_create_date AS cust_history,
	   s.total_sales,
	   CASE WHEN (CURRENT_DATE-c.customer_create_date) >= 365 THEN
	   		CASE WHEN s.total_sales > 5000 THEN 'VIP' ELSE 'Regular' END
			ELSE 'New' END AS cust_cat
FROM gold.dim_customers c
LEFT JOIN sales_by_customer s
ON c.customer_key = s.customer_key)
SELECT COUNT(*) total_customers,
		cust_cat AS customer_category
FROM cust_category
GROUP BY cust_cat
ORDER BY total_customers DESC;

WITH cust_segment AS (
select c.customer_id,
		s.customer_key,
		c.customer_firstname,
		c.customer_lastname,
		SUM(s.sls_price) AS total_sales,
		MIN(s.sls_order_dt) AS first_order_dt,
		MAX(s.sls_order_dt) AS last_order_dt,
		MAX(s.sls_order_dt)-MIN(s.sls_order_dt) AS life_span,
		CASE WHEN MAX(s.sls_order_dt)-MIN(s.sls_order_dt) >= 365 THEN
			 CASE WHEN SUM(s.sls_price) > 5000 THEN 'VIP' ELSE 'Regular' END
			 ELSE 'New' END AS cust_segment
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
GROUP BY c.customer_id,s.customer_key,c.customer_firstname,c.customer_lastname)
SELECT COUNT(*) total_customers,
		cust_segment AS customer_category
FROM cust_segment
GROUP BY cust_segment
ORDER BY total_customers DESC
	 
