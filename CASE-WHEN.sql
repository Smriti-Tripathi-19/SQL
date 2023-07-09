SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total,
	CASE
	WHEN total BETWEEN 0 AND 2 THEN 'POOR'
	ELSE 'RICH'
	END AS Categories
FROM
	Invoice
WHERE
	(total > 1.98) AND (BillingCity LIKE 'P%' OR BillingCity LIKE 'D%')
ORDER BY
	Categories
	