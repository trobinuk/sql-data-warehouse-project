--Performance Analysis

--Analyze the yearly performance of products by comparing each product's sales to both it's average sales performance and the previous year's sales.
SELECT sq.product_name,
	   sq.yr,
	   sq.sum_price AS year_wise_sales,
	   sq.avg_price AS average_sales,
	   LAG(sq.sum_price,1) OVER (PARTITION BY sq.product_name ORDER BY sq.yr) previous_year_sales
FROM (SELECT SUM(s.sls_price) sum_price,
			ROUND(AVG(s.sls_price)) avg_price, -- look how this is calculated
			p.product_name,
			EXTRACT(YEAR FROM s.sls_order_dt) yr
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	--WHERE s.sls_order_dt IS NOT NULL
	GROUP BY p.product_name,EXTRACT(YEAR FROM s.sls_order_dt)
	ORDER BY p.product_name,EXTRACT(YEAR FROM s.sls_order_dt)) sq
;


WITH yearly_product_sales AS(
SELECT SUM(s.sls_price) yearly_sales,
		p.product_name,
		EXTRACT(YEAR FROM s.sls_order_dt) yr
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE s.sls_order_dt IS NOT NULL
GROUP BY p.product_name,EXTRACT(YEAR FROM s.sls_order_dt))
SELECT product_name,
		yr,
		yearly_sales,
		ROUND(AVG(yearly_sales) OVER (PARTITION BY product_name)) avg_sales_by_product,
		yearly_sales-ROUND(AVG(yearly_sales) OVER (PARTITION BY product_name)) AS avg_diff,
		CASE WHEN yearly_sales-AVG(yearly_sales) OVER (PARTITION BY product_name) > 0
			 THEN 'Above Average'
			 WHEN yearly_sales-AVG(yearly_sales) OVER (PARTITION BY product_name) < 0
			 THEN 'Below Average'
			ELSE 'No Change' END AS avg_change,
		LAG(yearly_sales)  OVER (PARTITION BY product_name ORDER BY yr) previous_year_sales,
		yearly_sales-LAG(yearly_sales)  OVER (PARTITION BY product_name ORDER BY yr) AS prev_year_diff,
		CASE WHEN yearly_sales-LAG(yearly_sales)  OVER (PARTITION BY product_name ORDER BY yr) > 0
			 THEN 'Increase'
			 WHEN yearly_sales-LAG(yearly_sales)  OVER (PARTITION BY product_name ORDER BY yr) < 0
			 THEN 'Decrease'
			 WHEN LAG(yearly_sales)  OVER (PARTITION BY product_name ORDER BY yr) IS NULL 
			 THEN 'First Year Sales'
			ELSE 'No Change' END AS pv_change
FROM yearly_product_sales;

--How would you include the products that's not been sold ? dim_products as main table, fact_sales as left join table