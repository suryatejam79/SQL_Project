/* For Data Security we don't have to disturb the original data. So, we are inserting clean data into another where the level called as silver
to do that we combine the clean data queries which we have done in bronze test and final query below extracts clean data and dump that into silver level files before
we can follow two steps
*/
/* 1st step: without creating any table before and while dumping we can create and dump as below  but there is some issues here if miss any column
it will accept as there is no columns earlier so, It will accept as it is */

create table silver.crm_cust_info as 
select trim(cst_id) as cst_id,
trim(cst_key) as cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_marital_status)) = 'M' then "Married"
when upper(trim(cst_marital_status)) = 'S' then "Single"
else "Not Available" end as cst_marital_status, 
case when upper(trim(cst_gndr)) = "M" then "Male" 
when upper(trim(cst_gndr)) = 'F' then "Female"
else "Not Available" end as cst_gndr,
cst_create_date from
(select *, row_number() over(partition by cst_id order by cst_create_date desc) as rnk from bronze.crm_cust_info) as t
where cst_id is not null and rnk = 1;

/* second step: creating a table early and dumping clean data into that. this is best method as we created columns early if there is miss match in column count
it will not accept we can modify in query. below is the query for example */

insert into silver.crm_cust_info
select trim(cst_id) as cst_id,
trim(cst_key) as cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_marital_status)) = 'M' then "Married"
when upper(trim(cst_marital_status)) = 'S' then "Single"
else "Not Available" end as cst_marital_status, 
case when upper(trim(cst_gndr)) = "M" then "Male" 
when upper(trim(cst_gndr)) = 'F' then "Female"
else "Not Available" end as cst_gndr,
cst_create_date from
(select *, row_number() over(partition by cst_id order by cst_create_date desc) as rnk from bronze.crm_cust_info) as t
where cst_id is not null and rnk = 1;


select * from silver.crm_cust_info;

commit;


-- this for next table I have quality check in another file name data_quality_testing_methods

INSERT INTO silver.crm_prd_info
(prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    prd_nm,
    IFNULL(prd_cost, 0) AS prd_cost,
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        ELSE 'n/a'
    END AS prd_line,
    DATE(prd_start_dt) AS prd_start_dt,
    DATE_SUB(
        LEAD(prd_start_dt) OVER (PARTITION BY prd_nm ORDER BY prd_start_dt),
        INTERVAL 1 DAY
    ) AS prd_end_dt
FROM bronze.crm_prd_info;

commit;
