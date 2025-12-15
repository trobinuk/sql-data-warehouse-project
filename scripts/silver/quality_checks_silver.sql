/*
Purpose:
  Has to run these checks after loading into silver table
*/
--Check for Nulls or Duplicates in Primary key
--Expectation: No Result

------------------------------------------------------------------------------------------------------------------
------------------------------------------silver.crm_cust_info----------------------------------------------------
------------------------------------------------------------------------------------------------------------------
--Check for Nulls or Duplicates in Primary key
--Expectation: No Result

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Check for unwanted spaces
--Expectation: No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

--Check for unwanted spaces
--Expectation: No Result
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

--Check for Data Standardization & Consistency
--Expectation: 2 without NUll
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

--Check for Data Standardization & Consistency
--Expectation: 3 without NUll
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

--Check for unwanted spaces
--Expectation: No Result
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

----------------------------------------------------------------------------------------------------------------------
------------------------------------------silver.crm_prd_info----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
--Check for Nulls or Duplicates in Primary key
--Expectation: No Result
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL; --passed

--Check for unwanted spaces
--Expectation: No Result
SELECT prd_key
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key); --passed

--Check for unwanted spaces
--Expectation: No Result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm); --passed

--Check for Nulls or Negative (-ve)
--Expectation: No Result
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

--Check for distinct values (low cardinality) and no null values
--Expectation: No Result
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

--Check if prd_start_dt > prd_end_date
--Expectation: No Result
SELECT *
FROM silver.crm_prd_info
WHERE  prd_start_dt >= prd_end_dt ;

----------------------------------------------------------------------------------------------------------------------
------------------------------------------silver.crm_sales_details----------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

--Check if all sls_prd_key exist in silver.crm_prd_info Table
--Expectation: No Result
SELECT * FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT DISTINCT prd_key FROM silver.crm_prd_info); 

--Check if all sls_cust_id exist in silver.crm_cust_info Table
--Expectation: No Result
SELECT * FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT DISTINCT cst_id  FROM silver.crm_cust_info); 

--Check if all sls_sales is -ve
--Expectation: No Result
SELECT * FROM silver.crm_sales_details
WHERE sls_sales <= 0 OR  sls_quantity <= 0 OR sls_price <= 0;

--Check if the date is valid (Greater than today)
--Expectation: No Result
SELECT distinct sls_order_dt FROM silver.crm_sales_details
WHERE sls_order_dt < CAST('2010-01-01' AS Date) OR sls_order_dt > CURRENT_DATE;

SELECT * FROM silver.crm_sales_details
WHERE sls_ship_dt < CAST('2010-01-01' AS Date) OR sls_order_dt > CURRENT_DATE;

SELECT * FROM silver.crm_sales_details
WHERE sls_due_dt < CAST('2010-01-01' AS Date) OR sls_order_dt > CURRENT_DATE;

------------------------------------------silver.erp_cust_az12----------------------------------------------------

SELECT UPPER(TRIM(gen)) FROM silver.erp_cust_az12
WHERE gen != TRIM(gen);

SELECT * FROM silver.erp_cust_az12
WHERE gen IS NULL; --1472

SELECT DISTINCT gen FROM silver.erp_cust_az12

SELECT CAST(bdate AS DATE) FROM silver.erp_cust_az12;--18484

SELECT COUNT(*) FROM silver.erp_cust_az12; --18484

SELECT * FROM silver.erp_cust_az12;
---------------------------------------------------silver.erp_loc_a101-----------------------------

SELECT * FROM silver.erp_loc_a101 
WHERE cid NOT LIKE 'AW-%';

SELECT REPLACE(cid,'-','') cid,
	cntry 
FROM silver.erp_loc_a101 
WHERE cid LIKE 'AW-%';

SELECT DISTINCT cntry FROM silver.erp_loc_a101;

SELECT REPLACE(cid,'-','') cid,
		CASE WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
			WHEN cntry = 'DE' THEN 'Germany'
			WHEN cntry IS NULL or TRIM(cntry) = '' THEN 'n/a'
		ELSE TRIM(cntry) END cntry
FROM silver.erp_loc_a101;

SELECT REPLACE(cid,'-','') cid,
		CASE WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
			WHEN cntry = 'DE' THEN 'Germany'
			WHEN cntry IS NULL or TRIM(cntry) = '' THEN 'n/a'
		ELSE TRIM(cntry) END cntry
FROM silver.erp_loc_a101;
---------------------------------erp_px_cat_g1v2-----------------

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2;

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE TRIM(subcat) != subcat;

SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE TRIM(cat) != cat;

SELECT * FROM silver.erp_px_cat_g1v2
WHERE REPLACE(id,'_','-') NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info);

SELECT DISTINCT cat_id FROM silver.crm_prd_info
ORDER BY cat_id;

















