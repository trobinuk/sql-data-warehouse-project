--Find the Total Sales

SELECT * FROM gold.fact_sales;

SELECT SUM(sls_price) total_sales_price
FROM gold.fact_sales;

--Find how many items sold
SELECT SUM(sls_quantity) total_quantity 
FROM gold.fact_sales;

--Find the average selling price
SELECT AVG(sls_price) total_sales_price
FROM gold.fact_sales;--Average Total Selling Price

SELECT AVG(sls_sales) tot_sales_price_per_qnty
FROM gold.fact_sales;--Average Total Selling Price/quantity

--Find the total number of Orders


SELECT  COUNT(DISTINCT sls_ord_num) total_no_of_orders
FROM gold.fact_sales;--18484

--Find the total number of products
SELECT  COUNT(DISTINCT product_id) tot_products
FROM gold.dim_products;--295

SELECT  COUNT(product_id) tot_products
FROM gold.dim_products;--295

--Find the total number of customers 
SELECT  COUNT(DISTINCT customer_id) tot_customers
FROM gold.dim_customers;--18484

SELECT  COUNT(customer_id) tot_customers
FROM gold.dim_customers;--18484

--Find the total number of customers that has placed an order
SELECT  COUNT(DISTINCT customer_key) tot_custs 
FROM gold.fact_sales;--18484

SELECT  COUNT(customer_key) tot_custs 
FROM gold.fact_sales;--60398

SELECT DISTINCT customer_key tot_custs 
FROM gold.fact_sales;--18484


-- Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name,SUM(sls_price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name,SUM(sls_quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name,ROUND(AVG(sls_sales),2) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total no of Orders' AS measure_name,COUNT(DISTINCT sls_ord_num) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total no of Products' AS measure_name,COUNT(product_id) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total no of Customers' AS measure_name,COUNT(customer_id) AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Customers Placed Order' AS measure_name,COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales;

