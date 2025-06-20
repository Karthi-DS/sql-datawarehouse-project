create or alter procedure silver.load_silver as
begin 
declare @start_time datetime;
	declare @end_time datetime;
	begin try
		set @start_time = getdate();
		print '>> inserting into silver.crm_cust_info';
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
		print '--------inserted into silver.crm_cust_info------------';


		print '>> inserting into silver.crm_prd_info';
		truncate table silver.crm_prd_info;
		insert into silver.crm_prd_info(prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
		select prd_id,
		replace(SUBSTRING(prd_key,1,5),'-','_')as cat_id,
		SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost,0) as prd_cost,
		case 
			when upper(trim(prd_line)) = 'M' then 'Mountain'
			when upper(trim(prd_line)) = 'R' then 'Road'
			when upper(trim(prd_line)) = 'S' then 'Other Sales'
			when upper(trim(prd_line)) = 'T' then 'Touring'
			else 'n/a'
		end as prd_line,
		prd_start_dt,
		dateadd(day,-1,lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt from bronze.crm_prd_info;
		print '--------inserted into silver.crm_prd_info------------';


		print '>> inserting into silver.crm_sales_details';
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
		print '--------inserted into silver.crm_sales_details------------';


		print '>> inserting into silver.erp_cust_az12';
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
		print '--------inserted into silver.erp_cust_az12------------';


		print '>> inserting into silver.erp_loc_a101';
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
		print '--------inserted into silver.erp_loc_a101------------';


		print '>> inserting into silver.erp_px_cat_g1v2';
		truncate table silver.erp_px_cat_g1v2;
		insert into silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)
		select 
		id,
		trim(cat),
		trim(subcat),
		trim(maintenance)
		from bronze.erp_px_cat_g1v2;
		print '--------inserted into silver.erp_px_cat_g1v2------------';
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time)as varchar) + ' seconds';
		end try
		begin catch
			print('=============================');
			print 'Error Occured during loading bronze layer';
			print 'Error Message :' + error_message();
			print('=============================');
		end catch
end;