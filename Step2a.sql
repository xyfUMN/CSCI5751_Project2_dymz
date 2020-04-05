--*************************************
--CREATE Views on customer_monthly_sales_2019
--*************************************


SET VAR:database_name=dymz_sales;
--View: customer_monthly_sales_2019_view
--Customer id, customer last name, customer first name,
--year, month, aggregate total amount
--of all products purchased by month for 2019.


CREATE VIEW ${var:database_name}.customer_monthly_sales_2019_view as
SELECT s2.CustomerID, c.LastName,c.FirstName, s2.Month, s2.TotQuantity
FROM(SELECT s.CustomerID, sum(s.Quantity) as TotQuantity, Month(s.'Date') as Month
	FROM ${var:database_name}.sales2 as s
	WHERE Year(s.'Date')=2019
	group by s.CustomerID, Month(s.'Date') 
) AS s2
LEFT JOIN ${var:database_name}.customers2 as c ON c.CustomerID = s2.CustomerID