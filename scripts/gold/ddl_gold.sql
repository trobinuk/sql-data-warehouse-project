CREATE TABLE gold.dim_customer();
---
cst_id
cst_key
cst_firstname
cst_lastname
cst_marital_status
cst_gender
cst_create_date
cst_bdate
cst_country

CREATE TABLE gold.dim_product();
prd_id
cat_id
prd_key
prd_nm
prd_cost -- Should be this column in Fact Table ?
prd_line 
prd_start_date -- Should be this column in Fact Table ?
prd_end_date -- Should be this column in Fact Table ?

CREATE TABLE gold.fact_sales();
sls_ord_num --Should this be a dimension table
sls_prd_key --Should this be a dimension table
sls_cust_id --Only a key c
sls_order

--- dim_customer table query
CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cci.cst_id) AS customer_key,
	cci.cst_id AS customer_id,
	cci.cst_key AS customer_number,
	cci.cst_firstname AS first_name,
	cci.cst_lastname AS last_name,
	ela.cntry AS country,
	cci.cst_marital_status AS marital_status,
	CASE WHEN cci.cst_gndr != 'n/a' THEN cci.cst_gndr
		 ELSE COALESCE(eca.gen,'n/a') 
	END AS gender,
	eca.bdate AS birthdate,
	cci.cst_create_date AS create_date	
FROM silver.crm_cust_info cci
LEFT JOIN silver.erp_cust_az12 eca
ON cci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 ela
ON cci.cst_key = ela.cid;

SELECT DISTINCT gender FROM gold.dim_customers;

DELETE FROM silver.crm_cust_info
WHERE cst_key = 'A01Ass';

COMMIT;

SELECT * FROM gold.dim_customers;

SELECT COUNT(*) FROM silver.crm_cust_info cci;

-------------------------------------------- dim_product table query
CREATE OR REPLACE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY prd_id) AS product_key,
	cpi.prd_id AS product_id,
	cpi.prd_key AS product_number,
	cpi.prd_nm AS product_name,
	cpi.cat_id AS category_id,	
	epcg.cat AS category,
	epcg.subcat AS sub_category,
	epcg.maintenance AS maintenance_yn,
	cpi.prd_cost AS product_cost,
	cpi.prd_line AS product_line,
	cpi.prd_start_dt AS product_start_date
FROM silver.crm_prd_info cpi
LEFT JOIN silver.erp_px_cat_g1v2 epcg
ON cpi.cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL;--397

DROP VIEW gold.dim_products;

--------------------------------Data Quality check
SELECT * FROM gold.dim_productS;

SELECT COUNT(*),prd_key
FROM (
SELECT 
	cpi.prd_id,
	cpi.cat_id,
	cpi.prd_key,
	epcg.cat,
	epcg.subcat,
	cpi.prd_nm,
	cpi.prd_cost,
	cpi.prd_line,
	cpi.prd_start_dt,
	epcg.maintenance
FROM silver.crm_prd_info cpi
LEFT JOIN silver.erp_px_cat_g1v2 epcg
ON cpi.cat_id = epcg.id
WHERE cpi.prd_end_dt IS NULL)
GROUP BY prd_key
HAVING COUNT(*) > 1;

SELECT * FROM silver.erp_px_cat_g1v2;

SELECT * FROM silver.crm_prd_info;

--------------------------------------fact_sales query
CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT 
		csd.sls_ord_num AS order_number,
		dc.customer_key,
		dp.product_key,	
		csd.sls_order_dt AS order_date,
		csd.sls_ship_dt AS shipping_date,
		csd.sls_due_dt AS due_date,
		csd.sls_sales AS sales_amount,
		csd.sls_quantity AS quantity,
		csd.sls_price AS price
FROM silver.crm_sales_details csd
LEFT JOIN gold.dim_products dp
ON csd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers dc
ON csd.sls_cust_id = dc.customer_id; --60398

--Foreign Key Integrity for Dimensions
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key;

SELECT * FROM gold.fact_sales;

SELECT * FROM silver.crm_sales_details csd --60398

SELECT DISTINCT sls_prd_key FROM silver.crm_sales_details csd --60398

SELECT * FROM silver.crm_prd_info
WHERE prd_key = 'BK-T44U-54'

