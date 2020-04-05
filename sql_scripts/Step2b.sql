
SET VAR:database_name=dymz_sales;

CREATE VIEW ${var:database_name}.top_ten_customers_amount as
SELECT 
  	csp.CustomerID, 
	csp.LastName,
    csp.FirstName,
    SUM(csp.Quantity*csp.Price) as TotExpense
    FROM(
Select 
	c.CustomerID,
	c.LastName,
    c.FirstName,
    s.ProductID,
    s.Quantity,
    p.Price
    from ${var:database_name}.sales as s 
Inner join ${var:database_name}.customers as c on (c.CustomerID = s.CustomerID)
Inner join ${var:database_name}.products as p on (p.ProductID = s.ProductID)
) AS csp
Group by csp.CustomerID, csp.LastName, csp.FirstName
order by TotExpense DESC limit 10

