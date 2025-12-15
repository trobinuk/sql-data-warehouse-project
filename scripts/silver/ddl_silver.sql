DROP TABLE IF EXISTS silver.crm_cust_info CASCADE;
CREATE TABLE silver.crm_cust_info
(
cst_id VARCHAR(20),
cst_key VARCHAR(30),
cst_firstname VARCHAR(30),
cst_lastname VARCHAR(30),
cst_marital_status VARCHAR(10),
cst_gndr VARCHAR(10),
cst_create_date DATE,
dwh_create_dt DATE DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_prd_info CASCADE;
CREATE TABLE silver.crm_prd_info
(
prd_id INT,
cat_id VARCHAR(30),
prd_key VARCHAR(30),
prd_nm VARCHAR(60),
prd_cost INT,
prd_line VARCHAR(60),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_dt DATE DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_sales_details CASCADE;
CREATE TABLE silver.crm_sales_details
(
sls_ord_num VARCHAR(30),
sls_prd_key VARCHAR(30),
sls_cust_id VARCHAR(20),
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_dt DATE DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.erp_cust_az12 CASCADE;
CREATE TABLE silver.erp_cust_az12
(
cid VARCHAR(40),
bdate DATE,
gen VARCHAR(10),
dwh_create_dt DATE DEFAULT CURRENT_TIMESTAMP);

DROP TABLE IF EXISTS silver.erp_loc_a101 CASCADE;
CREATE TABLE silver.erp_loc_a101
(
cid VARCHAR(40),
cntry VARCHAR(20),
dwh_create_dt DATE DEFAULT CURRENT_TIMESTAMP);

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2 CASCADE;
CREATE TABLE silver.erp_px_cat_g1v2
(
id VARCHAR(40),
cat VARCHAR(40),
subcat VARCHAR(40),
maintenance VARCHAR(10),
dwh_create_dt DATE DEFAULT CURRENT_TIMESTAMP);
