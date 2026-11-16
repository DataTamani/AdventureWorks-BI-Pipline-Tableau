# AdventureWorks-BI-Pipline-Tableau
End-to-end BI projet : building a Snowflake data pipeline and creating a Tableau dashboard for AdventureWorks sales analytics.
# AdventureWorks BI Pipeline & Tableau Dashboard

##  Project Overview

This project consists of building an end-to-end Business Intelligence pipeline based on the AdventureWorks sample dataset.
The objective is to integrate sales and reference data into a unified analytical dataset to support Data Analysts in exploring sales performance and generating business insights.

##  Business Problem

AdventureWorks, a fictional company selling bicycle products, needs a unified dataset to analyze its sales performance.
The objective is to combine multiple sources of information, including sales transactions, customer data, product information, categories, subcategories, and territories, into a single analysis-ready dataset.

##  Tools Used

- Snowflake (Data Warehouse)
- SQL (Data cleaning and transformation)
- Tableau desktop (Data visualization and dashboard creation)

## 📂 Data Sources

The project uses the following datasets:

- AdventureWorks Sales 2015
- AdventureWorks Sales 2016
- AdventureWorks Sales 2017
- AdventureWorks Customer
- AdventureWorks Product
- AdventureWorks Product Categories
- AdventureWorks Product Subcategories
- AdventureWorks Territory

##  Data Pipeline Architecture

The pipeline follows a layered approach:

Raw Data  
⬇️  
RAW Layer (data ingestion)  
⬇️  
COR Layer (data cleaning and transformation)  
⬇️  
PRS Layer (analytical dataset)  
⬇️  
Tableau Dashboard

##  Data Preparation

The main steps performed were:

- Consolidation of sales data from 2015, 2016 and 2017
- Integration of sales data with customer, product and territory information
- Data cleaning and standardization
- Transformation of raw data into an analysis-ready dataset
- Creation of a unified dataset for Business Intelligence reporting
  <img width="1891" height="978" alt="image" src="https://github.com/user-attachments/assets/1b2b5065-9604-4eba-be2e-f5cea0c4af43" />

##  Final Analytical Dataset

The final output of the pipeline is a unified dataset containing sales information enriched with customer, product, category, subcategory and territory details.
This dataset is designed to support Data Analysts in performing sales analysis and creating dashboards.
<img width="1687" height="1096" alt="image" src="https://github.com/user-attachments/assets/f231251a-56bd-456e-98c0-06ea11c15c9c" />

##  Tableau Dashboard

The final analytical dataset will be used to build an interactive Tableau dashboard.

The dashboard will provide insights on:

- Sales evolution over time
- Product performance
- Customer analysis
- Geographic sales distribution

(Tableau dashboard engoing)


