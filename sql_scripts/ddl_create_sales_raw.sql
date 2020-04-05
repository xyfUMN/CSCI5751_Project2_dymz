--create impale database from raw sales data

--*************************************
--CREATE EXTERNAL TABLES on Raw Train Data
--*************************************

--command to run
--
--${var:database_name}
--Create Database

SET VAR:database_name=dymz_sales_raw;

Create Database IF NOT EXISTS ${var:database_name}
COMMENT 'Raw sales data imported from salesDB';


--Create External cars Table
CREATE EXTERNAL TABLE IF NOT EXISTS ${var:database_name}.Sales (
OrderID int,
SalesPersonID int,
CustomerID int,
ProductID int,
Quantity int,
`Date` TIMESTAMP)
COMMENT 'Sales table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/hdfs_salesdb/Sales2'
TBLPROPERTIES ("skip.header.line.count"="1");

--Create External cars Table
CREATE EXTERNAL TABLE IF NOT EXISTS ${var:database_name}.Employees (
EmployeeID int,
FirstName varchar,
MiddleInitial varchar,
LastName varchar,
Region varchar)
COMMENT 'Employees table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/hdfs_salesdb/Employees2'
TBLPROPERTIES ("skip.header.line.count"="1");

--Create External cars Table
CREATE EXTERNAL TABLE IF NOT EXISTS ${var:database_name}.Customers (
CustomerID int,
FirstName varchar,
MiddleInitial varchar,
LastName varchar)
COMMENT 'Customers table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/hdfs_salesdb/Customers2'
TBLPROPERTIES ("skip.header.line.count"="1");

--Create External cars Table
CREATE EXTERNAL TABLE IF NOT EXISTS ${var:database_name}.Products (
ProductID int,
Name varchar,
Price decimal)
COMMENT 'Products table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/hdfs_salesdb/Products'
TBLPROPERTIES ("skip.header.line.count"="1");


invalidate metadata;
compute stats ${var:database_name}.Sales;
compute stats ${var:database_name}.Employees;
compute stats ${var:database_name}.Customers;
compute stats ${var:database_name}.Products;
