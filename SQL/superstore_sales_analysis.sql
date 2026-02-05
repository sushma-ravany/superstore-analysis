    /* =========================================================
   Superstore End-to-End Data Analysis
   Layer		: SQL (Data Validation & Analytics Layer)
   Dataset		: Sample Superstore Orders(USA)
   Tool Used	: Microsoft SQL Server

   Description:
   - Performs data validation and exploratory analysis
   - Generates business KPIs and insights
   - Creates an analytics-ready view (vw_superstore_cleaned)
     to be consumed by Pandas and Power BI
   ========================================================= */


/* =====================================================
   SECTION 1: Dataset Overview & Validation
   ===================================================== */

SELECT COUNT(*) AS total_rows
FROM Orders;


SELECT 
    COUNT(DISTINCT Order_ID) AS distinct_orders,
    COUNT(DISTINCT Customer_ID) AS distinct_customers,
    COUNT(DISTINCT Product_ID) AS distinct_products
FROM Orders;



--------------------- Primary Key Analysis-----------------

-- Check if Order_id is unique

SELECT Order_ID, COUNT(*) 
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

--Result: Order_id is not unique


-- Check composite key (Order_id, Product_id)

SELECT Order_ID, Product_ID, COUNT(*) 
FROM Orders
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;


-- Result: No natural primary key exists.
-- Decision: Introduce a surrogate key (order_line_id) to uniquely identify rows.

ALTER TABLE Orders
ADD order_line_id INT IDENTITY(1,1);  --identity(1,1): start at 1 and increment by 1


ALTER TABLE Orders
ADD CONSTRAINT PK_orders
PRIMARY KEY (order_line_id);		--Adds Primary key constraint to order_line_id



/* =====================================================
   SECTION 2: Business KPIs
   ===================================================== */

--Overall Business KPIs
SELECT
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM Orders;



/* =====================================================
   SECTION 3: Time-Based Analysis
   ===================================================== */

-- Yearly Sales & Profit trend

SELECT
    YEAR(Order_Date) AS year,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY YEAR(Order_Date)
ORDER BY year;


-- Monthly Sales & Profit trend

SELECT
	YEAR(Order_Date) AS year,
	MONTH(Order_Date) AS month,
	DATENAME(MONTH, Order_Date) AS month_name,
	ROUND(SUM(Sales), 2) AS monthly_sales,
	ROUND(SUM(Profit), 2) AS monthly_profit
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date), DATENAME(MONTH, Order_Date) 
ORDER BY year, month;



/* =====================================================
   SECTION 4: Category & Product performance Analysis
   ===================================================== */

-------------------------Category Performance-------------------------------

-- Category sales and profit

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY Category
ORDER BY total_sales DESC;


--Loss Making Sub-Categories

SELECT
    Sub_Category,
    ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY sub_category
HAVING SUM(Profit) < 0
ORDER BY total_profit;


-------------------------Product Performance--------------------------

--Top 5 Products by Profit

SELECT TOP 5
	Product_Name,
	ROUND(SUM(Profit),2) AS total_profit
FROM Orders
GROUP BY Product_Name
ORDER BY total_profit DESC;


--Top 5 Loss-Making Products

SELECT TOP 5
	Product_Name,
	ROUND(SUM(Profit),2) AS total_profit
FROM Orders
GROUP BY Product_Name
HAVING SUM(Profit) < 0
ORDER BY total_profit ;


--Top products within each Category

SELECT 
	Category,
	Product_ID, 
	Product_Name,
	ROUND(SUM(Profit),2) AS product_profit,
	DENSE_RANK() OVER(PARTITION BY Category ORDER BY SUM(Profit) DESC) AS profit_rank
FROM Orders
GROUP BY Category, Product_ID, Product_Name;



/* =====================================================
   SECTION 5: Region Analysis
   ===================================================== */
   
--Region-wise Sales and Profit.

SELECT 
	Region,
	ROUND(SUM(Sales),2) AS region_sales,
	ROUND(SUM(Profit),2) AS region_profit
FROM Orders
GROUP BY Region
ORDER BY region_sales DESC;


--Revenue per State

SELECT 
	State, 
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit
FROM Orders
GROUP BY State
ORDER BY total_sales DESC;



/* =====================================================
   SECTION 6: Customer Analysis
   ===================================================== */

--Number of purchases per customer (most frequent buyers)

SELECT
	Customer_ID, 
	Customer_Name,
	COUNT(DISTINCT Order_ID) AS purchase_count
FROM Orders
GROUP BY Customer_ID, Customer_Name
ORDER BY purchase_count DESC;


-- Total spending by customers (top customers)

SELECT 
	Customer_ID, 
	Customer_Name,
	ROUND(SUM(Sales), 2) AS total_spent
FROM Orders
GROUP BY Customer_ID, Customer_Name
ORDER BY total_spent DESC;


--Customers with Above-Average Spending

WITH customer_sales AS
(
	SELECT 
		Customer_ID,
		Customer_Name,
		SUM(Sales) AS total_sales
	FROM Orders
	GROUP BY Customer_ID, Customer_Name
)

SELECT * 
FROM customer_sales
WHERE total_sales > (
	SELECT AVG(total_sales) FROM customer_sales);



/* =====================================================
   SECTION 7:  Others
   ===================================================== */

--Year-over-Year Growth

WITH yearly_sales AS
(
	SELECT
		YEAR(Order_Date) AS year,
		SUM(Sales) AS total_sales
	FROM Orders
	GROUP BY YEAR(Order_Date)
)

SELECT
    year,
    total_sales,
    total_sales - LAG(total_sales) OVER(ORDER BY year) AS yoy_growth,
    ROUND(
        (total_sales - LAG(total_sales) OVER(ORDER BY year)) * 100.0 /
        LAG(total_sales) OVER(ORDER BY year), 2
    ) AS yoy_growth_pct
FROM yearly_sales;


--Shipping Mode analysis

SELECT
    Ship_Mode,
    COUNT(*) AS order_count,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit
FROM Orders
GROUP BY Ship_Mode
ORDER BY total_profit DESC;


--Segment profitability

SELECT
    Segment,
    ROUND(SUM(Sales),2) AS sales,
    ROUND(SUM(Profit),2) AS profit
FROM Orders
GROUP BY Segment
ORDER BY profit DESC;


--Discount impact

SELECT
    Discount,
    COUNT(*) AS order_count,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(AVG(Profit),2) AS avg_profit
FROM Orders
GROUP BY Discount
ORDER BY Discount;




/* =====================================================
   SECTION 8:  FINAL DATA VIEW FOR ANALYTICS
   ===================================================== */
   
-- Final analytics-ready view
-- This view is consumed by Pandas and Power BI


CREATE OR ALTER VIEW vw_superstore_cleaned AS
SELECT
    Order_ID,
    Order_Date,
    Ship_Date,
    Customer_ID,
    Customer_Name,
    Segment,
    Region,
    State,
    Category,
    Sub_Category,
    Product_Name,
    Sales,
    Profit,
    Discount
FROM Orders;
