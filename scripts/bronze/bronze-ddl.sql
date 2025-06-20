use DataWarehouse;
if object_id('bronze.crm_cust_info', 'U') is not null
    drop table bronze.crm_cust_info;

create table bronze.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_material_status nvarchar(50),
	cst_gnder nvarchar(50),
	cst_create_date date
);

if object_id('bronze.crm_prd_info', 'U') is not null
    drop table bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost int,
    prd_line NVARCHAR(50),
    prd_start_dt date,
    prd_end_dt date
);

if object_id('bronze.crm_sales_details', 'U') is not null
    drop table bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
);

if object_id('bronze.erp_cust_az12', 'U') is not null
    drop table bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
    CID NVARCHAR(50),
    BDATE date,
    GEN NVARCHAR(50)
);

if object_id('bronze.erp_loc_a101', 'U') is not null
    drop table bronze.erp_loc_a101;


CREATE TABLE bronze.erp_loc_a101 (
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);

if object_id('bronze.erp_px_cat_g1v2', 'U') is not null
    drop table bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
);




