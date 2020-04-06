SET VAR:database_name=dymz_sales;

CREATE VIEW IF NOT EXISTS ${var:database_name}.customer_monthly_sales_2019_partitioned_view AS
SELECT a.customerid, b.lastname, b.firstname, a.salesyear, a.salesmonth, a.total
FROM (
    SELECT customerid, salesyear, salesmonth, SUM(totalsalesamount) AS total
    FROM ${var:database_name}.product_sales_partition
    WHERE salesyear = 2019
    GROUP BY customerid, salesyear, salesmonth) AS a
JOIN ${var:database_name}.customers b ON a.customerid = b.customerid
