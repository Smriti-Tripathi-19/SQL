/*
1) How many transactions took place between the years 2011 and 2012?
2) How much money did WSDA make in that period?
*/

--1
SELECT
count(date(InvoiceDate)) AS [TOTAL TRANSACTIONS BETWEEN 2011 AND 2012]
FROM
	Invoice
WHERE
	InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"
	
--2
SELECT
sum(total) AS [TOTAL SALES OF WSDA BETWEEN 2011 AND 2012]
FROM
	Invoice
WHERE
	InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"
	
	
/*
1) Get a list of customers who made purchases between 2011 and 2012
2) Get a list of customers,sales reps,total transaction amounts for each customer between 2011 and 2012
3) How many transactions are above the average transaction amount during the same time
4) What was the average transaction amount for each year that WSDA has been in Business?
*/

--1
SELECT
	c.FirstName,
	c.LastName,
	date(i.InvoiceDate),
	i.total,
	i.InvoiceId
FROM
	Invoice AS i
INNER JOIN
    Customer AS c
ON
	i.CustomerId = c.CustomerId
WHERE 
	i.InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"
ORDER BY
	i.total DESC
	
--2
SELECT
	c.FirstName,
	c.LastName,
	e.FirstName,
	e.LastName,
	e.EmployeeId,
	date(i.InvoiceDate),
	SUM(i.total),
	i.InvoiceId
FROM
	Invoice AS i
INNER JOIN
    Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
WHERE 
	i.InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"
GROUP BY
	i.CustomerId
	
--3
--To Get total average transaction of company within 2011-2012
SELECT
	round(avg(total),2) 
FROM	
	Invoice
WHERE
	InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"
--To get transactions that are above the average total transaction during 2011-2012
SELECT
	count(total)
FROM
	Invoice
WHERE
	total >
	(
	SELECT
		round(avg(total),2) 
	FROM	
		Invoice
	WHERE InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"
		
	)
AND InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31"

--4
SELECT
	avg(total),
	strftime("%Y",InvoiceDate) AS YEAR
FROM
	Invoice
GROUP BY
	YEAR
	
	
/*
1) Get a list of Employees who exceeded the average transaction amount from sales they generated during 2011-2012
2) Create a Commission Payout Column that displays each employee's commission based on 15% of the sales transaction amount, irrespective of whether that sale is greater than or less than 11.66
3) Which Employee made the highest commission?
4) List the customers that were served by that employee
5) Which customer made the highest purchase?
6) Look at that customer's record,is there anything suspicious?
7) Who is the primary person of interest?
*/

--1
SELECT
	e.FirstName,
	e.LastName,
	sum(i.total) AS TOT
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
WHERE
	(i.InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31") AND i.total > 11.66
GROUP BY
	e.EmployeeId
	
--2
SELECT
	e.FirstName,
	e.LastName,
	((sum(i.total))*0.15) AS COMMISSION
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
WHERE
	(i.InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31") 
GROUP BY
	e.EmployeeId
	
--3 
--JANE PEACOCK = 199.77

--4
SELECT
	c.FirstName,
	c.LastName,
	sum(i.total) AS TOT,
	((sum(i.total))*0.15) AS COMMISSION
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId = c.CustomerId
INNER JOIN
	Employee AS e
ON
	c.SupportRepId = e.EmployeeId
WHERE
	(i.InvoiceDate BETWEEN "2011-01-01" AND "2012-12-31") AND e.FirstName = "Jane"
GROUP BY
	c.CustomerId
ORDER BY
	TOT desc
	
--5 
--John Doeein = 1000.86

--6
SELECT
	*
FROM
	Customer
WHERE
	FirstName = "John" AND LastName = "Doeein"
--Yes, this record looks suspicious as it has NULL components

--7
--The primary suspect is Jane Peacock because John Doeein is her customer.