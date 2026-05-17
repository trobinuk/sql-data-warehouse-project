-- Which 5 products generate the highest revenue ?
-- I'm gonna assume revenue as just the total sales price (ignore the cost) revenue is not a profit

SELECT 
	RANK() OVER (ORDER BY SUM(s.sls_price) DESC) rn1,
	SUM(s.sls_price) total_sales,
	p.product_id
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_id
ORDER BY total_sales DESC;

SELECT 
	DENSE_RANK() OVER (ORDER BY SUM(s.sls_price) DESC) rn1,
	SUM(s.sls_price) total_sales,
	p.product_id
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_id
ORDER BY total_sales DESC;

SELECT 
	SUM(s.sls_price) total_sales,
	p.product_id,
	p.product_name
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_id,p.product_name
ORDER BY total_sales DESC
LIMIT 5;

SELECT 
	ROW_NUMBER() OVER (ORDER BY SUM(s.sls_price) DESC) rn1,
	SUM(s.sls_price) total_sales,
	p.product_id
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_id
ORDER BY total_sales DESC;

-- What are the 5 worst-performing products in terms of sales ?
SELECT 
	SUM(s.sls_price) total_sales,
	p.product_id,
	p.product_name
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_id,p.product_name
ORDER BY total_sales
LIMIT 5;

