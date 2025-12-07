#General Principles
  Naming Conventions: Use snake_case, with lowercase letters and underscores (_) to separate words.
  Avoid Reserved Words: Do not use SQL reserved words as object names.

  
#Table Naming Conventions

##Bronze
  -> All names must start with source system name, and table names must match their original names without renaming.
  -> <sourcesystem>_<entity> 
     <sourcesystem>: Name of the sourcesystem (eg: crm,erp).
     <entity>: Exact table name from the source system.
     Example: crm_customer_info -> customer information from the CRM system.
     
##Silver
  -> All names must start with source system name, and table names must match their original names without renaming.
  -> <sourcesystem>_<entity> 
     <sourcesystem>: Name of the sourcesystem (eg: crm,erp).
     <entity>: Exact table name from the source system.
     Example: crm_customer_info -> customer information from the CRM system.
     
##Gold
  -> All names must use meaninful, business-aligned names for tables, starting with the category prefix.
  -> <category>_<entity>
    <category>: Describes the role of the table, such as dim (dimension) or fact (fact table).
    <entity>: Descriptive name of the table, aligned with the business domain (eg: customers, products, sales).
    Example: dim_customers -> Dimension table for customer_data
             fact_sales -> Fact table containing sales transactions.
             agg_sales_monthly -> aggregated table containing the aggregated monthly data.


#Column Naming Conventions

##Surrogate Keys
  -> All primary keys in dimension table must use the suffix _key.
  -> <table_name>_key
    -> <table_name> : Refers to the name of the table or entity the key belongs to.
    -> _key: A suffix indicating that this column is a surrogate key.
    -> Example: customer_key -> Surrogate key in the dim_customers table.

##Technical Columns
  -> All technical columns must start with the prefix dwh_. followed by a descriptive name indicating the columns's purpose.
  -> dwh_<column_name>:
    -> dwh: Prefix exclusively for system-generated metadata.
    -> <column_name>: Descriptive name indicating the column's purpose.
    ->Example: dwh_load_date -> System-generated column used to store the date when the record was loaded.


#Stored Procedure:
  -> All stored procedures used for loading data must follow the naming pattern: load_<layer>.
      -> <layer>: Represents the layer being loaded, such as bronze, silver, or gold.
      -> Example:
          load_bronze -> Stored Procedure for loading data into the Bronze layer.
          load_silver -> Stored procedure for loading data into the Silver layer.




  
