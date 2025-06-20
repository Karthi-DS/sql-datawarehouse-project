use datawarehouse;
truncate table silver.erp_px_cat_g1v2;
insert into silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)
select 
id,
trim(cat),
trim(subcat),
trim(maintenance)
from bronze.erp_px_cat_g1v2;