# 📊 Superstore End-to-End Data Analysis (SQL | Pandas | Power BI)

## 📌 Project Overview
This project analyzes Superstore sales data to understand revenue drivers, profitability, customer behavior, shipping efficiency, and discount impact.  
The analysis follows a real-world analytics pipeline with **SQL as the source of truth**, **Pandas for exploration**, and **Power BI for visualization**.

---

## 🛠 Tools & Technologies
- SQL Server
- Python (Pandas, NumPy, Matplotlib)
- Power BI
- Jupyter Notebook

---

## 🧩 Analytics Workflow

### 1️⃣ SQL – Data Validation & Preparation (Foundation Layer)
SQL is used as the **system of record** for validating and preparing data before analysis.

**Key activities in SQL:**
- Selected relevant business columns (orders, products, customers, shipping, discounts)
- Checked for duplicate records at order–product level
- Validated total sales, profit, and order counts
- Ensured consistent data types and formats
- Created clean analytical views for downstream use

This ensures that all analysis is performed on **trusted and validated data**.

---

### 2️⃣ Pandas / Jupyter – Exploratory Data Analysis (Analysis Layer)
Python is used for in-depth exploration, feature engineering, and insight generation.

**Key analysis performed:**
- KPI Summary (Total Sales, Profit, Orders)
- Sales and Profit by Category
- Loss-Making Sub-Categories
- Regional Performance Analysis
- Customer-Level Insights
- Shipping Mode Analysis (volume, profit, delivery time)
- Discount vs Profit Analysis
- Feature engineering:
  - Shipping days
  - Order year
  - Profit percentage
- Data Visualization:
  - Monthly Sales Trend
  - Sales by Category
  - Profit Distribution
  - Profit by Sub-Category
  - Average Profit by Discount Level

Pandas is used to **analyze and enrich data**.

---

### 3️⃣ Power BI – Dashboarding & Storytelling (Presentation Layer)  (Planned and inprogress)
Power BI is used to communicate insights to business users through interactive dashboards.

**Dashboards include:**
- KPI cards for Sales, Profit, Orders
- Monthly sales trend
- Category and regional performance
- Shipping efficiency comparison
- Discount impact on profitability
- Customer contribution analysis

Power BI focuses on **clarity and decision-making**.

---

## 📌 Key Business Insights (High-Level)
- Standard Class shipping drives the highest revenue due to order volume, despite longer delivery times
- High discounts consistently reduce profitability without increasing order volume proportionately
- Certain sub-categories generate losses and require pricing or cost review
- Sales show an overall upward trend with seasonal fluctuations
- A small set of customers contributes a large share of total revenue

