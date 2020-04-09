SET VAR:database_name=dymz_sales;

Create Database IF NOT EXISTS ${var:database_name}
COMMENT 'Parquet sales data imported from sales_raw database';

--Create Parquet sales Table
CREATE TABLE IF NOT EXISTS ${var:database_name}.product_region_sales_partition
COMMENT 'Parquet region and sales materialized table'
STORED AS Parquet
AS
(select a.*, b.region
        from ${var:database_name}.product_sales_partition a, ${var:database_name}.employees b
        where a.salespersonid = b.employeeid);

invalidate metadata;
compute stats ${var:database_name}.product_region_sales_partition;
