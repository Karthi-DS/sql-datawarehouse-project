use DataWarehouse;
truncate table silver.erp_cust_az12;
insert into silver.erp_cust_az12 (cid,bdate,gen)
select 
case
	when cid like 'NAS%' then trim(SUBSTRING(cid,4,len(cid)))
	else trim(cid)
end as cid,
case
	when bdate < '1925-01-01' or bdate>getdate() then null
	else bdate
end as bdate,
case 
	when upper(trim(gen)) in ('M','Male') then 'Male'
	when upper(trim(gen)) in ('F','Female') then 'Female'
	else 'n/a'
end as gen
from bronze.erp_cust_az12;

