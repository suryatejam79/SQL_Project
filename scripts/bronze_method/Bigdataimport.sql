-- Importing Big Data in MYSQL from Excel have some methods to follow

-- importing file must be in CSV
-- and must create empty table in MYSQL

create database/schema bronze

CREATE TABLE bronze.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
)

-- this below rules should follow by dataset to bulk import into MYSQL
-- there shouldn't be any symbols like percentage or currency
-- the numbers shouldn't 
