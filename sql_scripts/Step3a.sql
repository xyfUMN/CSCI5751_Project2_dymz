SET VAR:database_name=dymz_sales;

Create Database IF NOT EXISTS ${var:database_name}
COMMENT 'Parquet sales data imported from sales_raw database';

--Create Parquet sales Table
CREATE TABLE IF NOT EXISTS ${var:database_name}.product_sales_partition
COMMENT 'Parquet product and sales materialized table'
STORED AS Parquet
AS
(select a.orderid AS OrderID,
        a.salespersonid AS SalesPersonID,
        a.customerid AS CustomerID,
        a.productid AS ProductID,
        b.name AS ProductName,
        b.price AS ProductPrice,
        a.quantity AS Quantity,
        (a.quantity)*(b.price) AS TotalSalesAmount,
        day(a.`date`) AS OrderDate,
        year(a.`date`) AS SalesYear,
        month(a.`date`) AS SalesMonth
        from ${var:database_name}.sales a, ${var:database_name}.products b
        where a.productid = b.productid);

invalidate metadata;
compute stats ${var:database_name}.product_sales_partition;
