/*
Purpose:
  This procedure get data from the source system, 
  And, Insert into the bronze layer.

Logging:
  Number of rows inserted into each table.
  Start time, End time, Duration for the overall procedure and each insert.

Parameters:
  No parameters

Usage Example:
  CALL bronze.load_bronze();
*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze() 
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
	RAISE NOTICE '===================================';
	RAISE NOTICE 'Loading Bronze Layer';
	RAISE NOTICE '===================================';
	RAISE NOTICE '-----------------------------------';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '-----------------------------------';
	RAISE NOTICE '# Truncating Table bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;
	RAISE NOTICE 'Inserting data into: bronze.crm_cust_info';
	
	start_time := clock_timestamp();
	
	COPY bronze.crm_cust_info FROM '/data/source_crm/cust_info.csv'
	WITH (FORMAT CSV, HEADER true, DELIMITER ',');
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'bronze.crm_cust_info - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'bronze.crm_cust_info insert took: %',duration;
	
	start_time := clock_timestamp();
	RAISE NOTICE '# Truncating Table bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;
	RAISE NOTICE 'Inserting data into: bronze.crm_prd_info';
	
	COPY bronze.crm_prd_info FROM '/data/source_crm/prd_info.csv' 
	WITH (FORMAT CSV, HEADER true, DELIMITER ',');
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'bronze.crm_prd_info - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'bronze.crm_prd_info insert took: %',duration;
	
	start_time := clock_timestamp();
	RAISE NOTICE '# Truncating Table bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;
	RAISE NOTICE 'Inserting data into: bronze.crm_sales_details';
	
	COPY bronze.crm_sales_details FROM '/data/source_crm/sales_details.csv' 
	WITH (FORMAT CSV, HEADER true, DELIMITER ',');
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'bronze.crm_sales_details - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'bronze.crm_sales_details insert took: %',duration;

	RAISE NOTICE '--------------------------------------------------------------------';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '--------------------------------------------------------------------';
	
	start_time := clock_timestamp();
	RAISE NOTICE '# Truncating Table bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;
	RAISE NOTICE 'Inserting data into: bronze.erp_cust_az12';
	
	COPY bronze.erp_cust_az12 FROM '/data/source_erp/CUST_AZ12.csv'     
	WITH (FORMAT CSV, HEADER true, DELIMITER ',');
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'bronze.erp_cust_az12 - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'bronze.erp_cust_az12 insert took: %',duration;
	
	start_time := clock_timestamp();
	RAISE NOTICE '# Truncating Table bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;
	RAISE NOTICE 'Inserting data into: bronze.erp_loc_a101';
	
	COPY bronze.erp_loc_a101 FROM '/data/source_erp/LOC_A101.csv'  
	WITH (FORMAT CSV, HEADER true, DELIMITER ',');
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'bronze.erp_loc_a101 - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'bronze.erp_loc_a101 insert took: %',duration;
	
	start_time := clock_timestamp();
	RAISE NOTICE '# Truncating Table bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	RAISE NOTICE 'Inserting data into: bronze.erp_px_cat_g1v2';
	
	COPY bronze.erp_px_cat_g1v2 FROM '/data/source_erp/PX_CAT_G1V2.csv' 
	WITH (FORMAT CSV, HEADER true, DELIMITER ',');
	
	GET DIAGNOSTICS r_count = ROW_COUNT;
	RAISE NOTICE 'bronze.erp_px_cat_g1v2 - Inserted rows %',r_count;
	end_time := clock_timestamp();
	duration := end_time-start_time;
	RAISE NOTICE 'bronze.erp_px_cat_g1v2 insert took: %',duration;
	
	batch_end_time := clock_timestamp();
	batch_duration := batch_end_time - batch_start_time;
	RAISE NOTICE '-- Procedure bronze.load_bronze took: %', batch_duration;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Error during the execution of procedure bronze.load_bronze %',SQLERRM;
END;
$$;
