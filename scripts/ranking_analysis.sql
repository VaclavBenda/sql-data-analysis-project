/*
===============================================================================
Ranking Analysis
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
SELECT TOP 5
	p.product_name, 
	SUM(sales_amount) AS total_revenue 
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- With window function
SELECT * FROM (
SELECT
	p.product_name,
	SUM(s.sales_amount) AS total_revenue,
	RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS rank_products
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
)t
WHERE rank_products <= 5;

--  What are the 5 worst-performing products in terms of sales
SELECT TOP 5
	p.product_name, 
	SUM(s.sales_amount) AS total_revenue 
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Window function
SELECT * FROM (
SELECT 
	p.product_name, 
	SUM(s.sales_amount) AS total_revenue,
	RANK() OVER(ORDER BY SUM(s.sales_amount)) AS rank_products
	FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
	ON p.product_key = s.product_key
GROUP BY p.product_name
)t
WHERE rank_products <= 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10 
	c.customer_key, 
	c.first_name, 
	c.last_name, 
	SUM(s.sales_amount) AS total_revenue 
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_orders, c.first_name, c.last_name;
