use datawarehouse;

select * from bronze.crm_sales_details;

-- check sales order number
select * from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num);

-- check sales product key
select * from bronze.crm_sales_details
where sls_prd_key not in 
(select prd_key from silver.crm_prd_info);

-- check sales customer id
select * from bronze.crm_sales_details
where sls_cust_id not in 
(select cst_id from silver.crm_cust_info);

-- check sales order date
select nullif(sls_order_dt,0)sls_order_dt from bronze.crm_sales_details 
where sls_order_dt <=0 or len(sls_order_dt) !=8;

select 
case 
	when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
	else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt
from bronze.crm_sales_details;


-- check sales shipping date
select nullif(sls_ship_dt,0)sls_ship_dt from bronze.crm_sales_details 
where sls_ship_dt <=0 or len(sls_ship_dt) !=8;

select 
case 
	when sls_ship_dt = 0 or len(sls_ship_dt) !=8 then null
	else cast(cast(sls_ship_dt as varchar) as date)
end as sls_ship_dt
from bronze.crm_sales_details;


-- check sales due date
select nullif(sls_due_dt,0)sls_due_dt from bronze.crm_sales_details 
where sls_due_dt <=0 or len(sls_due_dt) !=8;

select 
case 
	when sls_due_dt = 0 or len(sls_due_dt) !=8 then null
	else cast(cast(sls_due_dt as varchar) as date)
end as sls_due_dt
from bronze.crm_sales_details;


-- check quantity and sls_price
select distinct(sls_quantity),count(*) as no_of_columns from bronze.crm_sales_details group by sls_quantity;


select 
case 
	when sls_price is null then abs(sls_sales/sls_quantity)
	else abs(sls_price)
end as sls_price
from bronze.crm_sales_details where sls_price <0;



-- check sales 
select * from bronze.crm_sales_details where sls_sales < 0 or sls_sales is null; 
select
case 
	when sls_sales < 0 then 0
	else sls_sales
end as sls_sales
from bronze.crm_sales_details;

select * from
(select 
case 
	when sls_sales != (sls_price * sls_quantity) or sls_sales < 0 or sls_sales is null then abs(sls_price * sls_quantity)
	else abs(sls_sales)
end as sls_sales
from bronze.crm_sales_details) as sales
where sls_sales < 0 or sls_sales is null






