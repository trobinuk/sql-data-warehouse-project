WITH category_wise_sales AS(
SELECT SUM(s.sls_price) sales_by_cat,
	p.product_category	
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_category)
SELECT product_category,
		sales_by_cat,
		SUM(sales_by_cat) OVER () AS total_sales,
		CONCAT(ROUND((sales_by_cat/SUM(sales_by_cat) OVER ())*100,2),'%') AS percentage
FROM category_wise_sales;
/*
SELECT CAST(sls_price AS FLOAT)
FROM gold.fact_sales;*/