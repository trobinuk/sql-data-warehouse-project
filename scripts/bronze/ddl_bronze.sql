DROP SCHEMA IF EXISTS bronze CASCADE;
CREATE SCHEMA bronze;

DROP SCHEMA IF EXISTS silver CASCADE;
CREATE SCHEMA silver;

DROP SCHEMA IF EXISTS gold CASCADE;
CREATE SCHEMA gold;

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
prd_end_dt DATE
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
