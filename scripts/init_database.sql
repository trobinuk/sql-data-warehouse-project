/*
======================================================================
CREATE DATABASE AND SCHEMAS
======================================================================
Script Purpose:
  This script creates a new database named 'Datawarehouse' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionaly the script sets up three schemas
  bronze, silver, gold
WARNING:
  Executing this command will drop the schema's if already exists.
  All data in the schema will be permanently deleted. Proceed with caution
*/

CREATE DATABASE datawarehouse;

DROP SCHEMA IF EXISTS bronze CASCADE;
CREATE SCHEMA bronze;

DROP SCHEMA IF EXISTS silver CASCADE;
CREATE SCHEMA silver;

DROP SCHEMA IF EXISTS gold CASCADE;
CREATE SCHEMA gold;
