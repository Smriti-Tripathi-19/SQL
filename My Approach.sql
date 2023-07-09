SELECT
	e.FirstName,
	e.LastName,
	il.UnitPrice,
	SUM(il.Quantity) AS [QUANTITY BOUGHT],
	e.EmployeeId,
	SUM(i.total) AS [CUSTOMER TOTAL],
	date(i.InvoiceDate) AS IFD
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	InvoiceLine AS il
ON
	il.InvoiceId = i.InvoiceId
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
WHERE 
	(IFD BETWEEN "2011-01-01" AND "2012-12-31") AND ((il.UnitPrice*il.Quantity) != i.total)
GROUP BY
	e.EmployeeId
ORDER BY
	e.EmployeeId