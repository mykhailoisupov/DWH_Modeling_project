# Shop Data Warehouse (DWH) Project

## Overview
This project implements a **dimensional data warehouse** for a retail business called **Shop DWH**.  
It follows a standard multi-layered architecture with **raw**, **staging**, and **mart** layers, modeling data for analytics and reporting.

---

## Business Case
The business represents an **online retail shop** that sells products across multiple categories.  
The data warehouse is designed to support insights into:
- Customer purchasing behavior  
- Product and category performance  
- Monthly sales trends  

---

## Architecture and Data Lineage
The DWH follows a **three-layer architecture**:

1. **Raw Layer**  
   Stores unprocessed data from multiple sources (e.g., customer, product, and order systems).

2. **Staging Layer**  
   Cleans, standardizes, and filters raw data (e.g., trimming strings, validating prices).

3. **Mart Layer**  
   Provides analytics-ready data using **fact and dimension tables**, aggregated into sales marts.

### Data Lineage Visualization
Visualized in `Lineage_schema.jpg`


## Data Model
The project uses a **dimensional modeling approach**.

### Fact Table
- **fact_sales** — central table containing sales measures such as quantity, revenue, and order totals.

### Dimension Tables
- **dim_customer** — customer details and registration info  
- **dim_product** — product and category data  
- **dim_date** — calendar attributes derived from order dates  

---

## Transformation Logic
Each data pipeline follows these steps:
1. Extract raw data from multiple sources (`raw_*` tables).  
2. Clean and standardize data in the staging layer (`stg_*` tables).  
3. Join and transform data to populate fact and dimension tables.  
4. Aggregate key metrics in **marts** for analytical use.

---

## Data Marts
Two analytical marts are built:
- **mart_monthly_category_sales** — summarizes sales by month and category.  
- **mart_customer_sales_summary** — aggregates customer-level purchasing metrics.



## Author
Developed by **Mykhailo Isupov** and **Dmytro Lupashko** 

*Readme made with help from ChatGPT(markdown styling)*
