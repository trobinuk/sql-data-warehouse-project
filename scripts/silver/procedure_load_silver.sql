/*
Purpose:
  This procedure select/get data from the bronze layer, do the data transformations (data cleansing, standardization, Handle null values, casting, use metadata columns, Remove unwanted spaces)
  And, Insert into the silver layer.

Logging:
  Number of rows inserted into each table.
  Start time, End time, Duration for the overall procedure and each insert.

Parameters:
  No parameters

Usage Example:
  CALL silver.load_silver();
*/
CREATE OR REPLACE PROCEDURE silver.load_silver() 
LANGUAGE plpgsql
AS $$
DECLARE
	batch_start_time TIMESTAMPTZ;
	batch_end_time TIMESTAMPTZ;
	batch_duration INTERVAL;
	start_time TIMESTAMPTZ;
	end_time TIMESTAMPTZ;
	duration INTERVAL;
	r_count INTEGER;
BEGIN
	batch_start_time := clock_timestamp();
	RAISE NOTICE '====================================================================';
	RAISE NOTICE 'Loading Silver Layer';
	RAISE NOTICE '====================================================================';
	RAISE NOTICE '--------------------------------------------------------------------';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '--------------------------------------------------------------------';
	RAISE NOTICE 'Truncating Table silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	RAISE NOTICE 'Inserting Data into: silver.crm_cust_info';

	start_time := clock_timestamp();
	INSERT INTO silver.crm_cust_info (
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
		)
	SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) cst_firstname,
	TRIM(cst_lastname) cst_lastname,
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		 ELSE 'n/a' END AS cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		 ELSE 'n/a' END AS cst_gndr,
	cst_create_date 
	FROM
	(SELECT ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last,*
	FROM bronze.crm_cust_info) t
	WHERE t.flag_last = 1; 
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'silver.crm_cust_info - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'silver.crm_cust_info insert took: %',duration;
	
	
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;
	RAISE NOTICE 'Inserting Data into: silver.crm_prd_info';

	INSERT INTO silver.crm_prd_info (
				prd_id,
				cat_id,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt)
	SELECT
		prd_id,
		SUBSTRING(prd_key,1,5) cat_id,
		SUBSTRING(prd_key,7,LENGTH(prd_key)) prd_key,
		prd_nm,
		COALESCE(prd_cost,0) prd_cost,
		CASE TRIM(prd_line)
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
		END prd_line,
		prd_start_dt,
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 prd_end_dt
	FROM bronze.crm_prd_info;
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'silver.crm_prd_info - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'silver.crm_prd_info insert took %',duration;

	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;
	RAISE NOTICE 'Inserting Data into: silver.crm_sales_details';
	
	INSERT INTO silver.crm_sales_details(
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price)		
	SELECT sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN LENGTH(CAST(sls_order_dt AS VARCHAR(8))) = 8
				THEN  CAST(CAST(sls_order_dt AS VARCHAR(8)) AS DATE)
				ELSE NULL
			END sls_order_dt,
			CASE WHEN LENGTH(CAST(sls_ship_dt AS VARCHAR(8))) = 8
				THEN  CAST(CAST(sls_ship_dt AS VARCHAR(8)) AS DATE)
				ELSE NULL
			END sls_ship_dt,
			CASE WHEN LENGTH(CAST(sls_due_dt AS VARCHAR(8))) = 8
				THEN  CAST(CAST(sls_due_dt AS VARCHAR(8)) AS DATE)
				ELSE NULL
			END sls_due_dt,
			CASE WHEN sls_sales <= 0 
				THEN sls_quantity*sls_price 
				ELSE sls_sales
			END sls_sales,
			sls_quantity,
			abs(sls_price) sls_price
	FROM bronze.crm_sales_details;
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'silver.crm_sales_details - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'silver.crm_sales_details insert took %',duration;

	RAISE NOTICE '--------------------------------------------------------------------';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '--------------------------------------------------------------------';
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;
	RAISE NOTICE 'Inserting Data into: silver.erp_cust_az12';
	
	
	INSERT INTO silver.erp_cust_az12(
				cid,
				bdate,
				gen)
	SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid)) 
			ELSE cid END cid,
			CASE WHEN bdate > CURRENT_DATE THEN NULL 
			ELSE bdate END bdate,
			CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			ELSE 'n/a' END gen		
	FROM bronze.erp_cust_az12;
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'silver.erp_cust_az12 - Inserted rows %',r_count;
	RAISE NOTICE 'Truncating Table silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;
	RAISE NOTICE 'Inserting Data into: silver.erp_loc_a101';
	
	INSERT INTO silver.erp_loc_a101(
				cid,
				cntry)
	SELECT REPLACE(cid,'-','') cid,
			CASE WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
				WHEN cntry = 'DE' THEN 'Germany'
				WHEN cntry IS NULL or TRIM(cntry) = '' THEN 'n/a'
			ELSE TRIM(cntry) END cntry
	FROM bronze.erp_loc_a101;
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'silver.erp_loc_a101 - Inserted rows %',r_count;
	RAISE NOTICE 'Truncating Table silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	RAISE NOTICE 'Inserting Data into: silver.erp_px_cat_g1v2';
	
	INSERT INTO silver.erp_px_cat_g1v2(
				id,
				cat,
				subcat,
				maintenance)
	SELECT REPLACE(id,'_','-') id,
			cat,
			subcat,
			maintenance
	FROM bronze.erp_px_cat_g1v2;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'silver.erp_px_cat_g1v2 - Inserted rows %',r_count;
	RAISE NOTICE 'silver.erp tables insert took: %',duration;
	
	batch_end_time := clock_timestamp();
	batch_duration := batch_end_time - batch_start_time;
	RAISE NOTICE 'Procedure silver.load_silver took: %', batch_duration;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Error during the execution of procedure silver.load_silver %',SQLERRM;
END;
$$;
