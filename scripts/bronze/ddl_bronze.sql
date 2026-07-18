/*

==============================================================================================================================
DDL Script: Create Bronze Tables
===============================================================================================================================
SCRIPT PURPOSE:
  This script creates tables in the 'bronze' schema, dropping existing tables if they alsready exist.
  It also tracks the ETL duration
  Run this script to re-define the DDL structure of 'bronze' Tables
============================================================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS -- STORED PROCEDURE: Save frequently used SQL code in stored procedures in database. TO EXECUTE: EXEC bronze.load_bronze
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; -- TRACK ETL DURATION: Helps to Identify bottlenecks, optimize performance, monitor trends, detect issues
		BEGIN TRY
			SET @batch_start_time = GETDATE();
			PRINT '=================================================================';
			PRINT 'Loading Bronze Layer';
			PRINT '=================================================================';

			PRINT '-----------------------------------------------------------------';
			PRINT 'Loading CRM Tables';
			PRINT '-----------------------------------------------------------------';
			

			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.crm_cust_info';
			TRUNCATE TABLE bronze.crm_cust_info; --- TO EMPTY THE TABLE FIRST BEFORE LOADING THE DATA IN CASES WHERE WE MISTAKENLY LOAD THE DATA INTO THE TABLE MORE THAN ONCE

	
			PRINT '>> Inserting Data into Table: bronze.crm_cust_info';
			BULK INSERT bronze.crm_cust_info
			FROM 'C:\Users\Mayor\OneDrive\Desktop\DWH\datasets\source_crm\cust_info.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
			PRINT '-----------------------------'


			SET @start_time = GETDATE();
			PRINT '>> Truncating Table: bronze.crm_prd_info';
			TRUNCATE TABLE bronze.crm_prd_info;

	
			PRINT '>> Inserting Data into Table: bronze.crm_prd_info';
			BULK INSERT bronze.crm_prd_info
			FROM 'C:\Users\Mayor\OneDrive\Desktop\DWH\datasets\source_crm\prd_info.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
			PRINT '-----------------------------'


			SET @start_time = GETDATE()
			PRINT '>> Truncating Table:bronze.crm_sales_details';
			TRUNCATE TABLE bronze.crm_sales_details;


			PRINT '>> Inserting Data into Table: bronze.crm_sales_details';
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\Mayor\OneDrive\Desktop\DWH\datasets\source_crm\sales_details.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
			PRINT '-----------------------------'



			PRINT '-----------------------------------------------------------------';
			PRINT 'Loading ERP Tables';
			PRINT '-----------------------------------------------------------------';


			SET @start_time = GETDATE()
			PRINT '>> Truncating Table: bronze.erp_cust_az12';
			TRUNCATE TABLE bronze.erp_cust_az12;


			PRINT '>> Inserting Data into Table:bronze.erp_cust_az12';
			BULK INSERT bronze.erp_cust_az12
			FROM 'C:\Users\Mayor\OneDrive\Desktop\DWH\datasets\source_erp\cust_az12.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
			PRINT '-----------------------------'


			SET @start_time = GETDATE()
			PRINT '>> Truncating Table:bronze.erp_loc_a101';
			TRUNCATE TABLE bronze.erp_loc_a101;


			PRINT '>> Inserting Data into Table:bronze.erp_loc_a101';
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\Mayor\OneDrive\Desktop\DWH\datasets\source_erp\loc_a101.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
			PRINT '-----------------------------'


			SET @start_time = GETDATE()
			PRINT '>> Truncating Table:bronze.erp_px_cat_g1v2';
			TRUNCATE TABLE bronze.erp_px_cat_g1v2;


			PRINT '>> Inserting Data into Table:bronze.erp_px_cat_g1v2';
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\Mayor\OneDrive\Desktop\DWH\datasets\source_erp\px_cat_g1v2.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
			PRINT '-----------------------------'

			SET @batch_end_time = GETDATE();
			PRINT '=========================================='
			PRINT 'Loading Bronze Layer is completed';
			PRINT '	 - Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
			PRINT '=========================================='

		END TRY
		-- TRY, CATCH: SQL runs the TRY block, and if it fails, it runs the CATCH block to handle the error
		BEGIN CATCH
			PRINT'======================================';
			PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
			PRINT'Error Message' + ERROR_MESSAGE();
			PRINT'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT'Error Message' + CAST (ERROR_STATE() AS NVARCHAR)
			PRINT'======================================';
		END CATCH 
END
