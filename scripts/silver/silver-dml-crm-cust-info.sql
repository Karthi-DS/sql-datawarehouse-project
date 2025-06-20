truncate table silver.crm_cust_info;
insert into silver.crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gnder,cst_create_date)
select 
cst_id,
cst_key,
trim(cst_firstname) cst_firstname,
trim(cst_lastname) cst_lastname,
case
	when upper(trim(cst_material_status)) = 'S' then 'Single'
	when upper(trim(cst_material_status)) = 'M' then 'Married'
	else 'n/a'
end as cst_marital_status,
case
	when upper(trim(cst_gnder)) = 'F' then 'Female'
	when upper(trim(cst_gnder)) = 'M' then 'Male'
	else 'n/a'
end as cst_gnder,
cst_create_date from (
select *,row_number() over (partition by cst_id order by cst_create_date desc) as flag_last from bronze.crm_cust_info)
as delete_table where flag_last=1;




