--*************************************
--CREATE Parquet TABLES
--*************************************

SET VAR:database_name=dymz_sales;

SET VAR:source_database=dymz_sales_raw;

Create Database IF NOT EXISTS ${var:database_name}
COMMENT 'Parquet sales data imported from sales_raw database';

--Create Parquet sales Table
CREATE TABLE IF NOT EXISTS ${var:database_name}.sales
COMMENT 'Parquet sales table'
STORED AS Parquet
AS
SELECT * from ${var:source_database}.sales;


--Create Parquet employees Table
CREATE TABLE IF NOT EXISTS ${var:database_name}.employees
COMMENT 'Parquet employees table'
STORED AS Parquet
AS
SELECT * from ${var:source_database}.employees;

--Create Parquet customers Table
CREATE TABLE IF NOT EXISTS ${var:database_name}.customers
COMMENT 'Parquet customers table'
STORED AS Parquet
AS
SELECT * from ${var:source_database}.customers;


--Create Parquet cars Table
CREATE TABLE IF NOT EXISTS ${var:database_name}.products
COMMENT 'Products Parquet table'
STORED AS Parquet
As
SELECT * from ${var:source_database}.products;

invalidate metadata;
compute stats ${var:database_name}.sales;
compute stats ${var:database_name}.employees;
compute stats ${var:database_name}.customers;
compute stats ${var:database_name}.products;
