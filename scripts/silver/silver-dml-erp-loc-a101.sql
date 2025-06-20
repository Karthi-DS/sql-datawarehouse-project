use DataWarehouse;
truncate table silver.erp_loc_a101;
insert into silver.erp_loc_a101 (cid,cntry)
select  
trim(replace(cid,'-',''))cid,
CASE 
  WHEN trim(upper(cntry)) = 'DE' THEN 'Denmark'
  WHEN trim(upper(cntry)) IN ('USA', 'US', 'UNITED STATES') THEN 'United States'
  when trim(cntry) = '' or cntry is null then 'n/a'
  else trim(cntry)
END as cntry
from bronze.erp_loc_a101;

