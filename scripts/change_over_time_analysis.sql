/*
===============================================================================
Change Over Time Analysis
===============================================================================
*/

-- Analyse sales performance over time
SELECT 
	YEAR(order_date) AS year_date, 
	MONTH(order_date) AS month_date,
	COUNT(DISTINCT (customer_key)) AS total_customers,
	SUM(sales_amount) AS total_sales, 
	SUM(quantity) AS total_quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

SELECT
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT (customer_key)) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date is NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- Demonstration only: FORMAT() is useful for display, but not ideal for grouping/sorting because it can sort alphabetically instead of chronologically.
SELECT
	FORMAT(order_date, 'yyyy-MMM') AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT (customer_key)) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
