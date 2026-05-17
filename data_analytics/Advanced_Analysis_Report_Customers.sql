/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
CREATE OR REPLACE VIEW gold.report_customers AS
WITH cust_base_query AS (
select c.customer_id,
		s.customer_key,
		CONCAT(c.customer_firstname,' ',c.customer_lastname) AS customer_name,
		EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM c.customer_birth_date) AS customer_age,
		s.sls_ord_num,
		s.product_key,
		s.sls_order_dt,		
		s.sls_quantity,
		s.sls_price AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE s.sls_order_dt IS NOT NULL),

customer_aggregation AS (
SELECT customer_key,
		customer_id,
		customer_name,
		customer_age,
		COUNT(DISTINCT sls_ord_num) total_orders,
		SUM(sales_amount) total_sales,
		SUM(sls_quantity) total_quantity,
		COUNT(DISTINCT product_key) total_products, --SELECT * FROM gold.fact_sales WHERE customer_key = 997 ORDER BY product_key,
		MIN(sls_order_dt) first_order_date,
		MAX(sls_order_dt) last_order_date,
		MAX(sls_order_dt) - MIN(sls_order_dt) AS life_span_in_days,
		(EXTRACT(YEAR FROM AGE(MAX(sls_order_dt),MIN(sls_order_dt)))*12) + 
		EXTRACT(MONTH FROM AGE(MAX(sls_order_dt),MIN(sls_order_dt))) AS life_span_in_mon
FROM cust_base_query
GROUP BY customer_key,customer_id,customer_name,customer_age)

SELECT customer_key,
		customer_id,
		customer_name,
		customer_age,
		CASE WHEN customer_age < 20 THEN 'Under 20'
			 WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
			 WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
			 WHEN customer_age BETWEEN 40 AND 49 THEN '40-49'
			 WHEN customer_age BETWEEN 50 AND 59 THEN '50-59'
			 ELSE '60 and above' END AS age_segment,
		total_orders,
		total_sales,
		total_quantity,
		total_products, 
		first_order_date,
		last_order_date,
		(EXTRACT(YEAR FROM AGE(CURRENT_DATE,last_order_date))*12) + 
		EXTRACT(MONTH FROM AGE(CURRENT_DATE,last_order_date)) AS recency,
		life_span_in_days,
		life_span_in_mon,
		CASE WHEN life_span_in_mon >= 12 THEN
			 CASE WHEN total_sales > 5000 THEN 'VIP' ELSE 'Regular' END
			 ELSE 'New' END AS customer_segment,
		CASE WHEN total_quantity = 0 THEN 0
			 ELSE (total_sales/total_quantity) END AS average_order_value,
		CASE WHEN life_span_in_mon = 0 THEN 0 -- There are zeros, you can modify(in place of 0) those into total_sales
			 ELSE ROUND((total_sales/life_span_in_mon),2) END AS average_monthly_spend
FROM customer_aggregation;


		