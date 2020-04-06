--*************************************
--CREATE View on top_ten_customers_amount Data
--*************************************

SET VAR:database_name=dymz_sales;

CREATE VIEW IF NOT EXISTS ${var:database_name}.top_ten_customers_amount_view as

select C.CustomerID,sub.TotalDollarAmount,C.FirstName,C.MiddleInitial,C.LastName
from ${var:database_name}.customers C
	inner join
	(
		SELECT
		    CustomerID,
		    Sum(S.Quantity*P.Price)
			AS TotalDollarAmount
		FROM ${var:database_name}.sales S INNER JOIN ${var:database_name}.products P
		ON S.ProductID = P.ProductID
		GROUP BY CustomerID
    	) AS sub
	on C.CustomerID=sub.CustomerID
 
ORDER BY sub.TotalDollarAmount DESC limit 10;
