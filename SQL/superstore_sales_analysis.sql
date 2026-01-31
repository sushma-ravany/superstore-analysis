/* =====================================================
   Superstore Sales & Profit Analysis (USA)
   Dataset Scope : Retail orders from the United States
   Tool Used     : Microsoft SQL Server
   Purpose       : Analyze sales performance, profitability,
                   trends, and year-over-year growth
   ===================================================== */


/* =====================================================
   SECTION 1: Dataset Overview & Validation
   ===================================================== */


SELECT COUNT(*) AS total_rows
FROM Orders;


SELECT 
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(DISTINCT product_id) AS distinct_products
FROM orders;


--------------------- Primary Key Analysis-----------------

-- Check if order_id is unique

SELECT order_id, COUNT(*) 
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Check composite key (order_id, product_id)

SELECT order_id, product_id, COUNT(*) 
FROM orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Result: No natural primary key exists.
-- Decision: Introduce a surrogate key (order_line_id) to uniquely identify rows.

ALTER TABLE orders
ADD order_line_id INT IDENTITY(1,1);  --identity(1,1): start at 1 and increment by 1


ALTER TABLE orders
ADD CONSTRAINT PK_orders
PRIMARY KEY (order_line_id);		--Adds Primary key constraint to order_line_id



/* =====================================================
   SECTION 2: Business KPIs
   ===================================================== */

--Overall Business KPIs
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;



/* =====================================================
   SECTION 3: Time-Based Analysis
   ===================================================== */

-- Yearly Sales & Profit trend

SELECT
    YEAR(order_date) AS year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year;


-- Monthly Sales & Profit trend

select
	year(Order_Date) as year,
	month(Order_Date) as month,
	round(sum(Sales), 2) as monthly_sales,
	round(sum(Profit), 2) as monthly_profit
from Orders
group by year(Order_Date), month(Order_Date)
order by Year, Month



/* =====================================================
   SECTION 4: Category & Product performance Analysis
   ===================================================== */

-------------------------Category Performance-------------------------------

-- Category sales and profit

SELECT
    Category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_sales DESC;


--Loss Making Sub-Categories

SELECT
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;


-------------------------Product Performance--------------------------

--Top 5 Products by Profit

SELECT top 5
	Product_Name,
	ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY Product_Name
ORDER BY total_profit DESC;


--Top 5 Loss-Making Products

select top 5
	Product_Name,
	ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY Product_Name
HAVING SUM(profit) < 0
ORDER BY total_profit ;


--Rank Products by Profit

SELECT 
	Product_ID, 
	Product_Name,
	ROUND(sum(Profit),2) AS product_profit,
	DENSE_RANK() OVER(ORDER BY SUM(Profit) DESC) AS profit_rank
FROM Orders
GROUP BY Product_ID, Product_Name;



/* =====================================================
   SECTION 5: Region & Customer Analysis
   ===================================================== */
   
--Region-wise Sales and Profit.

SELECT 
	region,
	ROUND(SUM(Sales),2) AS Total_Sales,
	ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY region;


--Customers with Above-Average Spending

SELECT 
	Customer_Name,
	ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY Customer_Name
HAVING SUM(sales) > (SELECT AVG(sales) FROM orders);



/* =====================================================
   SECTION 5: Year-over-Year Growth Analysis
   ===================================================== */

WITH yearly_sales AS(
			SELECT
				YEAR(order_date) AS year,
				SUM(sales) AS total_sales
			FROM Orders
			GROUP BY YEAR(order_date)
		)

SELECT
	year,
	total_sales,
	total_sales - LAG(total_sales, 1, 0) OVER(ORDER BY year) AS yoy_growth
FROM yearly_sales;


