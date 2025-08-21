# Technical-Test-1-Data-Analyst-

# Client Behavior Analysis

This repository contains SQL scripts for analyzing user behavior, transaction patterns, and spending trends. It includes data cleaning, database creation, and analysis queries.

## Project Overview

The analysis is based on three datasets:

- `users_data.csv` – containing demographic and financial details of users  
- `cards_data.csv` – containing card details, types, and credit limits  
- `transactions_data.csv` – containing transaction histories including amounts, merchants, and errors  

The workflow uses **PostgreSQL** with **Visual Studio Code** to import and preprocess the data, followed by a comprehensive SQL script (`analysis.pgsql`) that performs all data cleaning, transformation, and segmentation.

---

## Deliverables

1. **SQL Script** – `analysis.pgsql` with all cleaning, transformations, and analysis queries.  
2. **README.md** – this file with setup and execution instructions.  
3. **Visualization Dashboard** – interactive charts and tables, compatible with Looker Studio.  
4. **Presentation** – summary of insights and findings (PDF).

---

## Tools & Workflow

- **Database Engine**: PostgreSQL – for storing, querying, and managing relational datasets  
- **SQL Editor**: Visual Studio Code – write, edit, and execute SQL scripts efficiently    
- **Data Processing**: SQL scripts – for cleaning, transforming, and segmenting client data  
- **Visualization & Insights**: Looker Studio – to create interactive dashboards and summarize findings  
- **Workflow Highlights**: End-to-end pipeline from raw CSV import → data cleaning → analysis → dashboard visualization  

---
## How to Run SQL Scripts
### 1. Prepare the Database

1. Ensure PostgreSQL is installed and running on your machine.  
2. Open **VSCode** with a SQL extension (e.g., PostgreSQL Explorer) and connect to PostgreSQL.  
3. Create a new database for this project, e.g., `mandiri`.

### 2. Create New Tables
- Define tables for `users`, `cards`, and `transactions` based on the CSV structure.
- Use `\copy` commands or VSCode import tools to load:
  - `users_data.csv`  
  - `cards_data.csv`  
  - `transactions_data.csv` 

### 3. Data Cleaning & Schema Refinement
- Remove unwanted characters (like `$`) from financial columns.  
- Convert columns to appropriate data types (numeric, date, timestamp).  
- Add foreign key constraints to maintain relational integrity.

### 4.Run Analysis

Once the database is set up and the CSV data is imported and cleaned, the analysis proceeds as follows:

└─User Overview
  - Count total users by gender.
  - Understand user distribution and demographics.

└─Card Analysis
  - Analyze card types and brands.
  - Calculate the total number of cards and average credit limits per type.

└─Transaction Insights
  - Identify top merchant cities by transaction volume and total spending.
  - Segment users based on credit scores to understand financial health.

└─Client Prioritization
  - Calculate total spending and transaction counts per client.
  - Compute a loyalty score combining income and transaction activity.
  - Identify top clients based on loyalty score for targeted actions.

└─Spending Behavior
  - Analyze spending by age groups.
  - Calculate total spending and average transaction per age group.
  - Highlight high-value age segments for marketing or acquisition focus.

└─Error Monitoring
  - Categorize transactions as "Error" or "No Error".
  - Determine frequency and type of errors to detect potential issues in processing.

└─User Segmentation: New vs Returning
  - Determine each client’s first transaction month to classify New Users.
  - Classify returning clients as Returning Users.
  - Aggregate metrics per month and segment:
    -  Total users
    -  Total transactions
    -  Total spending
    -  Average transaction value

### 5. Export Results
- Prepare CSVs or tables for dashboards.
- Connect to Looker Studio for visualization.

# Important Links:

[https://lookerstudio.google.com/reporting/eb8dbef5-0615-4ccb-be8a-c80c75bd0c17]

---
  Goal: The analysis transforms raw transactional data into actionable insights to understand user behavior, prioritize high-value clients, and inform business decisions such as marketing, retention, and client acquisition strategies.
