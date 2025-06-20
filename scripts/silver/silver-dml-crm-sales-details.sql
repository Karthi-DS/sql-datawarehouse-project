use DataWarehouse;
truncate table silver.crm_sales_details;
insert into silver.crm_sales_details (sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
select
trim(sls_ord_num) as sls_ord_num,
sls_prd_key,
sls_cust_id,
case 
	when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
	else try_cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
case 
	when sls_ship_dt = 0 or len(sls_ship_dt) !=8 then null
	else try_cast(cast(sls_ship_dt as varchar) as date)
end as sls_ship_dt,
case 
	when sls_due_dt = 0 or len(sls_due_dt) !=8 then null
	else try_cast(cast(sls_due_dt as varchar) as date)
end as sls_due_dt,
case 
	when sls_sales != (sls_price * sls_quantity) or sls_sales < 0 or sls_sales is null then abs(sls_price * sls_quantity)
	else abs(sls_sales)
end as sls_sales,
abs(sls_quantity) as sls_quantity,
case 
	when sls_price is null then abs(sls_sales/sls_quantity)
	else abs(sls_price)
end as sls_price
from bronze.crm_sales_details;

