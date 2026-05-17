/*
===============================================================================
Cumulative Analysis
===============================================================================
*/

-- Calculate the total sales per month
-- and the running total of sales over time
SELECT
	date_month,
	total_sales,
	total_quantity,
	SUM(total_sales) OVER(ORDER BY date_month) AS running_total_sales,
	SUM(total_sales) OVER(ORDER BY date_month) / SUM(total_quantity) OVER(ORDER BY date_month) AS running_average_price
FROM (
	SELECT 
		DATETRUNC(month, order_date) AS date_month, 
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)t
ORDER BY date_month;
