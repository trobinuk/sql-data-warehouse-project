DROP DATABASE IF EXISTS datawarehouse1;
CREATE DATABASE datawarehouse1;

DROP TABLE IF EXISTS bronze.crm_cust_info CASCADE;
CREATE TABLE bronze.crm_cust_info
(
cst_id INT,
cst_key VARCHAR(30),
cst_firstname VARCHAR(30),
cst_lastname VARCHAR(30),
cst_marital_status VARCHAR(3),
cst_gndr VARCHAR(3),
cst_create_date DATE
);

DROP TABLE IF EXISTS bronze.crm_prd_info CASCADE;
CREATE TABLE bronze.crm_prd_info
(
prd_id INT,
prd_key VARCHAR(30),
prd_nm VARCHAR(60),
prd_cost INT,
prd_line VARCHAR(3),
prd_start_dt DATE,
prd_end_date DATE
);

DROP TABLE IF EXISTS bronze.crm_sales_details CASCADE;
CREATE TABLE bronze.crm_sales_details
(
sls_ord_num VARCHAR(30),
sls_prd_key VARCHAR(30),
sls_cust_id VARCHAR(20),
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

DROP TABLE IF EXISTS bronze.erp_cust_az12 CASCADE;
CREATE TABLE bronze.erp_cust_az12
(
cid VARCHAR(40),
bdate DATE,
gen VARCHAR(10));

DROP TABLE IF EXISTS bronze.erp_loc_a101 CASCADE;
CREATE TABLE bronze.erp_loc_a101
(
cid VARCHAR(40),
cntry VARCHAR(20));

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2 CASCADE;
CREATE TABLE bronze.erp_px_cat_g1v2
(
id VARCHAR(40),
cat VARCHAR(40),
subcat VARCHAR(40),
maintenance VARCHAR(10));

COPY bronze.crm_cust_info FROM '/Users/robinsontamilselvan/Desktop/DataWarehouseProject/datasets/source_crm/cust_info.csv'
WITH (FORMAT CSV,HEADER true,DELIMITER ',');

SELECT * FROM bronze.crm_cust_info;

/*
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker cp /Users/robinsontamilselvan/Desktop/DataWarehouseProject/datasets/source_crm/ datawarehouse-postgres:/data/
Successfully copied 4.47MB to datawarehouse-postgres:/data/
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker cp /Users/robinsontamilselvan/Desktop/DataWarehouseProject/datasets/source_erp/ datawarehouse-postgres:/data/
Successfully copied 969kB to datawarehouse-postgres:/data/
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker exec -it datawarehouse-postgres psql -U rtamil -d datawarehouse -c "
COPY bronze.crm_cust_info FROM '/data/source_crm/cust_info.csv'
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
"

COPY 18494
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker exec -it datawarehouse-postgres psql -U rtamil -d datawarehouse -c "
COPY bronze.crm_prd_info FROM '/data/source_crm/prd_info.csv' 
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
"

COPY 397
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker exec -it datawarehouse-postgres psql -U rtamil -d datawarehouse -c "
COPY bronze.crm_sales_details FROM '/data/source_crm/sales_details.csv' 
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
"

COPY 60398
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker exec -it datawarehouse-postgres psql -U rtamil -d datawarehouse -c "
COPY bronze.erp_cust_az12 FROM '/data/source_erp/CUST_AZ12.csv'     
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
"

COPY 18484
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker exec -it datawarehouse-postgres psql -U rtamil -d datawarehouse -c "
COPY bronze.erp_loc_a101 FROM '/data/source_erp/LOC_A101.csv'  
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
"

COPY 18484
robinsontamilselvan@Robinsons-MacBook-Pro DataWarehouseProject % docker exec -it datawarehouse-postgres psql -U rtamil -d datawarehouse -c "
COPY bronze.erp_px_cat_g1v2 FROM '/data/source_erp/PX_CAT_G1V2.csv' 
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
"

COPY 37

*/
