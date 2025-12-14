# Data Dictionary for Gold Layer  
## Overview  
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.  

### **1.gold.dim_customers**
**Purpose:** Stores customer details enriched with demographic and geographic data.  
**Columns:**  
| Column Name | Data Type | Description |
| ----------- | --------- | ----------- |
| customer_key | INT | Surrogate key uniquely identifying each record in the dimension table
| customer_id | VARCHAR(30) | Unique numerical identifier assigned to each customer
| customer_number | VARCHAR(30) | Alphanumeric identifier representing the customer, used for tracking and referencing.
| first_name | VARCHAR(30) | The customer's first name, as recorded in the system.
| last_name | VARCHAR(30) | The customer's last name or family name.
| country | VARCHAR(20) | The country of residence for the customer (e.g., 'Australia')
| marital_status | VARCHAR(10) | The marital status of the customer (e.g., 'Married' )
| gender | VARCHAR(10) | The gender of the customer (e.g., 'Male')
| birthdate | Date | the date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1995-12-30)
| create_date | Date | The date and time when the customer record was created in the system  

### **2.gold.dim_products**
**Purpose:** Provides information about the products and their attributes.  
**Columns:**  
| Column Name | Data Type | Description |
| ----------- | --------- | ----------- |
| product_key | INT | Surrogate key uniquely identifying each record in the dimension table
| product_id | VARCHAR(30) | Unique numerical identifier assigned to the product.
| product_number | VARCHAR(30) | Alphanumeric identifier representing the product, used for tracking and referencing.
| product_name | VARCHAR(30) | The name of the product.
| category_id | VARCHAR(30) | The numerical value the category gets assigned.
| category | VARCHAR(20) | The category that the product belongs to (e.g., 'Bikes','Components')
| sub_category | VARCHAR(10) | The sub category that the product belongs to (e.g., '','')
| maintenance_yn | VARCHAR(10) | Indicates whether the product requires maintenance (e.g., 'Yes','No)
| product_cost | INT | The cost or base price of the product.
| product_line | VARCHAR(30) | The product line or series to which the product belongs (e.g., 'Road','Mountain')
| product_start_date | Date | The date and time when the product was created in the system  

### **3.gold.fact_Sales**
**Purpose:** Stores transactional sales data for analytical purposes.  
**Columns:**  
| Column Name | Data Type | Description |
| ----------- | --------- | ----------- |
| order_number | VARCHAR(30)  | A unique Alphanumeric identifier representing each sales order.
| product_key | VARCHAR(30) | Surrogate key linking the order to the product in the dimension table,
| customer_key | INT | Surrogate key linking the order to the customer in the dimension table,
| order_date | Date | The date when the order was placed.
| shipping_date | Date | The date when the order was shipped to the customer.
| due_date | Date | The date when the order payment was due.
| sales_amount | INT | The total monetary amount that got charged to the customer Formula: (quantity * price)
| quantity | INT | The quantity of order.
| price | INT | The price of each quantity of the order.


