SELECT * 
FROM gold.fact_sales;

-- Find the date of the first and last order
SELECT MIN(sls_order_dt) first_order_date,
	MAX(sls_order_dt) last_order_date,
	AGE(MAX(sls_order_dt),MIN(sls_order_dt)) diff,
	MAX(sls_order_dt)-MIN(sls_order_dt) dif1,
	EXTRACT(YEAR FROM AGE(MAX(sls_order_dt),MIN(sls_order_dt))) year_diff
FROM gold.fact_sales;

--Find the oldest and youngest customer

SELECT MIN(customer_birth_date) oldest_birthdate,
		AGE(CURRENT_DATE,MIN(customer_birth_date)) diff_oldest,
		MAX(customer_birth_date) youngest_birthdate,
		AGE(CURRENT_DATE,MAX(customer_birth_date)) diff_youngest
FROM gold.dim_customers;