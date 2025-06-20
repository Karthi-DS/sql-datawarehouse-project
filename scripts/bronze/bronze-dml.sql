create or alter procedure bronze.load_bronze as 
begin
	declare @start_time datetime;
	declare @end_time datetime;
	begin try
		set @start_time = getdate();
		print 'Loading bronze layer';
		print '=======================================================';
		print 'loading bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
		bulk insert bronze.crm_cust_info 
		from "C:\Users\KARTHEESVARAN\project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv"
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)

	

		select count(*) as no_of_rows from bronze.crm_cust_info;

		print '=======================================================';
		print 'loading bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		bulk insert bronze.crm_prd_info 
		from "C:\Users\KARTHEESVARAN\project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv"
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)

		select count(*) as no_of_rows from bronze.crm_prd_info;

		print '=======================================================';
		print 'loading bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		bulk insert bronze.crm_sales_details 
		from "C:\Users\KARTHEESVARAN\project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)

		select count(*) as no_of_rows from bronze.crm_sales_details;

		print '=======================================================';
		print 'loading bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		bulk insert bronze.erp_cust_az12 
		from "C:\Users\KARTHEESVARAN\project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv"
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)

		select count(*) as no_of_rows from bronze.erp_cust_az12;

		print '=======================================================';
		print 'loading bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		bulk insert bronze.erp_loc_a101 
		from "C:\Users\KARTHEESVARAN\project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)

		select count(*) as no_of_rows from bronze.erp_loc_a101;

		print '=======================================================';
		print 'loading bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		bulk insert bronze.erp_px_cat_g1v2
		from "C:\Users\KARTHEESVARAN\project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		)

		select count(*) as no_of_rows from bronze.erp_px_cat_g1v2;
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


