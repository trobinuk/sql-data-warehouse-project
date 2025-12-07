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





  
