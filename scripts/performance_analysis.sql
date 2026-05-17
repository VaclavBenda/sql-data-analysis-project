/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
	SELECT 
		p.product_name,
		YEAR(s.order_date) AS order_year, 
		SUM(s.sales_amount) AS current_sales
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(s.order_date), p.product_name
), yearly_agg AS(

	SELECT 
		order_year,
		product_name,
		current_sales,
		AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
		current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
		LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
		current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py
	FROM yearly_product_sales
)
SELECT 	
	order_year,
	product_name,
	current_sales,
	avg_sales,
	CASE
		WHEN diff_avg < 0 THEN 'Below Avg'
		WHEN diff_avg > 0 THEN 'Above Avg'
		ELSE 'Avg'
	END AS avg_change,
	diff_avg,
	py_sales,
	diff_py,
	CASE 
		WHEN diff_py > 0 THEN 'Increase'
		WHEN diff_py < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS py_change
FROM yearly_agg
ORDER BY product_name, order_year;
