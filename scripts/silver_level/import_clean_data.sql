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
