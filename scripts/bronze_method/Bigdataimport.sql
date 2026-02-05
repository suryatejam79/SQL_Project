-- Importing Big Data in MYSQL from Excel have some methods to follow

-- and must create empty table in MYSQL

set global local_infile = 1; -- to accept by SQL from local files

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
-- the numbers shouldn't contain any seperator
-- Make sure number is in the format of yyyy-mm-dd
-- Not required but make sure first column doesn't have null values
-- File must save in CSV

-- After following all this conditions save the data into particular location in PC
-- C:/ProgramData/MySQL/MySQL Server 8.0/Uploads


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- data will load in fraction of seconds

select * from crm_cust_info;

-- follow the same step for other datasets that you want to import

-- create empty table for product info
create table bronze.crm_prd_info(
prd_id int,
prd_key nvarchar(100),
prd_nm nvarchar(100),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime);

-- load bulk data using below query in fraction of seconds
LOAD DATA LOCAL INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from crm_prd_info;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

LOAD DATA LOCAL INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from crm_sales_details;

commit;
