-- using datawarehouse database
use DataWarehouse;

select * from bronze.crm_prd_info;

-- no null or duplicate keys in data;
select count(*),prd_id from bronze.crm_prd_info group by prd_id having count(*)>1 or prd_id is null;

select *,replace(SUBSTRING(prd_key,1,5),'-','_')as cat_id,SUBSTRING(prd_key,7,len(prd_key)) as sales_id from bronze.crm_prd_info

select id from bronze.erp_px_cat_g1v2;

select cat_id from
(select *,replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id from bronze.crm_prd_info) as crm_prd where cat_id not in
(select distinct id from bronze.erp_px_cat_g1v2);

select sls_prd_key from bronze.crm_sales_details;

select crm_sales_key from
(select *,SUBSTRING(prd_key,7,len(prd_key)) as crm_sales_key from bronze.crm_prd_info) as crm_prd where crm_sales_key in 
(select distinct trim(sls_prd_key) from bronze.crm_sales_details);

-- check for unwanted spaces in prd_nm
select prd_nm from bronze.crm_prd_info
where prd_nm != trim(prd_nm);

--check from product cost is null or 0
select * from bronze.crm_prd_info
where prd_cost <0 or prd_cost is null;

--check prd_line
select distinct(prd_line) from bronze.crm_prd_info;

--check start date
select * from bronze.crm_prd_info where prd_end_dt<prd_start_dt;
