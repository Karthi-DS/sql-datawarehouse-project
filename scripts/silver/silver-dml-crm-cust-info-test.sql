select * from silver.crm_cust_info;

select count(*) as no_of_rows,count(distinct(cst_id)) as no_of_pkey from silver.crm_cust_info where cst_id is not null;

select *,row_number()
over (partition by cst_id order by cst_create_date desc) as flag_last from silver.crm_cust_info

select cst_id,count(*) from silver.crm_cust_info group by cst_id having count(*)>1; 
select * from (
select *,row_number() over (partition by cst_id order by cst_create_date desc) as flag_last from silver.crm_cust_info)
as delete_table where flag_last!=1;

select cst_firstname from silver.crm_cust_info where cst_firstname != trim(cst_firstname);

select cst_lastname from silver.crm_cust_info where cst_lastname != trim(cst_lastname);

select distinct(cst_marital_status) from silver.crm_cust_info;
select distinct(cst_gnder) from silver.crm_cust_info;

