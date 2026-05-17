--Analyze Sales Performance Over Time

SELECT * FROM gold.fact_sales;

SELECT EXTRACT(YEAR FROM sls_order_dt) yr,
	    SUM(sls_price) Total_sales_by_year
FROM gold.fact_sales
WHERE sls_order_dt IS NOT NULL
GROUP BY EXTRACT(YEAR FROM sls_order_dt);

SELECT EXTRACT(YEAR FROM sls_order_dt) yr,
	    SUM(sls_price) OVER (ORDER BY EXTRACT(YEAR FROM sls_order_dt)) Total_sales_by_year
FROM gold.fact_sales
GROUP BY EXTRACT(YEAR FROM sls_order_dt);

SELECT * FROM 
	(SELECT
		yr,
		mon,
		total_sales_by_year,
		LEAD(total_sales_by_year) OVER (ORDER BY yr,mon) ld_sales
	FROM (SELECT EXTRACT(YEAR FROM sls_order_dt) yr,
			   EXTRACT(MONTH FROM sls_order_dt) mon,
			   SUM(sls_price) total_sales_by_year
		FROM gold.fact_sales
		WHERE sls_order_dt IS NOT NULL
		GROUP BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt)
		ORDER BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt))) sq
WHERE total_sales_by_year < ld_sales;

SELECT INITCAP('RUNNING TOTAL SALES BY YEAR')
------------- Cumulative
--"Running Total Sales By Year"
SELECT DISTINCT
	   EXTRACT(YEAR FROM sls_order_dt) yr,
	   SUM(sls_price) OVER (ORDER BY EXTRACT(YEAR FROM sls_order_dt)) cum_sales_by_year
FROM gold.fact_sales
WHERE sls_order_dt IS NOT NULL
ORDER BY EXTRACT(YEAR FROM sls_order_dt);

--"Running Total Sales By Month"
SELECT DISTINCT
	   EXTRACT(YEAR FROM sls_order_dt) yr,
	   EXTRACT(MONTH FROM sls_order_dt) mon,
	   SUM(sls_price) OVER (ORDER BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt)) cum_sales_by_year
FROM gold.fact_sales
WHERE sls_order_dt IS NOT NULL
ORDER BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt);

--Moving Average Sales by Month
SELECT DISTINCT
	   EXTRACT(YEAR FROM sls_order_dt) yr,
	   EXTRACT(MONTH FROM sls_order_dt) mon,
	   ROUND(AVG(sls_price) OVER (ORDER BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt))) run_avg_by_month
FROM gold.fact_sales
WHERE sls_order_dt IS NOT NULL
ORDER BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt);


SELECT yr,
		mon,
		total_sales_by_year,
		SUM(total_sales_by_year) OVER (ORDER BY yr,mon) cum_sum
FROM	(SELECT EXTRACT(YEAR FROM sls_order_dt) yr,
	   EXTRACT(MONTH FROM sls_order_dt) mon,
	   SUM(sls_price) total_sales_by_year
FROM gold.fact_sales
WHERE sls_order_dt IS NOT NULL
GROUP BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt)
ORDER BY EXTRACT(YEAR FROM sls_order_dt),EXTRACT(MONTH FROM sls_order_dt));
