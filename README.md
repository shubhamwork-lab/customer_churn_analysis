# Data Analytics Portfolio Project_2

## Skills & Key Learnings
This project demonstrates practical skills in the following areas:
* **MySQL & ETL**: Creating databases, staging/production tables, views, and handling null values.
* **Data Modeling & DAX (Power BI)**: Building relationships, creating calculated columns & measures, KPI tracking.
* **Data Transformation**: Using Power Query for feature engineering and categorization.
* **Machine Learning**: Building and evaluating a Random Forest churn prediction model.
* **Predictive Analytics**: Generating churn predictions and integrating them into BI dashboards.
* **Data Visualization**: Creating interactive, user-friendly dashboards with slicers, tooltips, and drill-down insights.
* **End-to-End Analytics Pipeline**: From raw data → ETL → Visualization → Prediction → Business Insights.

---

## Overview
This project demonstrates a complete **Customer Churn Analytics & Prediction workflow** using Telecom customer data.

It covers the full process of:
* Performing ETL operations in MySQL.
* Building a Power BI dashboard to analyze churn behavior.
* Developing a machine learning model to predict future churners.
* Creating a churn profiling dashboard for targeted marketing.

The goal is to showcase practical skills in **data engineering, business intelligence, and predictive analytics** suitable for a professional portfolio.

---

## Dataset
- The dataset used in this project is about Telecom Customer Churn Data  
- Format: CSV

### Features Included:

* Customer demographics (Gender, Age, Marital Status)
* Services subscribed (Internet type, Device protection, Backup, etc.)
* Account details (Contract type, Payment method, Tenure)
* Revenue & Monthly charges
* Customer status (Stayed / Churned)
* Churn category & churn reason

---

## Tools

* **MySQL Workbench**: Database creation, ETL process, views
* **Power BI**: Data modeling, DAX measures, interactive dashboards
* **Python**: Pandas, Scikit-learn, RandomForestClassifier
* **Jupyter Notebook**: ML workflow & model evaluation

---

## Steps

1. **Data Import & ETL (MySQL Workbench)**
   - Imported CSV into SQL Server
   - Cleaned data and handled null values
   - Created production tables and analytical views

2. **Data Modeling (Power BI)**
   - Connected SQL views to Power BI
   - Created calculated columns and DAX measures
   - Defined KPIs (Total Customers, Churn, Churn Rate, New Joiners)

3. **Dashboard Creation**
   - Built summary and churn analysis pages
   - Added slicers, tooltips, and interactive visuals
   - Designed clean and consistent layout

4. **Machine Learning Model**
   - Prepared and encoded data in Python
   - Trained Random Forest classifier
   - Evaluated model performance (84% accuracy)
   - Generated churn predictions for new customers

5. **Churn Profiling**
   - Integrated predictions into Power BI
   - Built churn prediction dashboard
   - Analyzed high-risk customer segments

---

## Dashboard
The Power BI dashboard includes:
- KPI cards with key metrices
- Demographic and account analysis
- Geographic churn insights
- Service usage breakdown
- Interactive filters and tooltips
- Churn prediction page with high-risk customer profiling

---
