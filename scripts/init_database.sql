use master;
go

if exists(select name from sys.databases where name = 'DataWarehouse')
begin
	alter database DataWarehouse set single_user with rollback immediate;
	drop database DataWarehouse;
end;
go

--create database DataWarehouse

create database DataWarehouse;
go

use DataWarehouse;
go

--CREATE SCHEMAS

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO