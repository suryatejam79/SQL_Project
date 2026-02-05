/* We don't apply any constratints to table in bronze level because we don't know the quality of data 
now we are going to cleaning the data without disturbing actual data and importing data into Silver level to do that we have run some data quality testing */

/* I need cst_id should be primary key for that i need to clean data that cst_id shouldn't have any duplicates and null values to check that below query will follow */

select cst_id, count(*) from crm_cust_info
group by cst_id
having count(*) >1;

-- to show the data which are not duplicate

select * from (select *, row_number() over(partition by cst_id order by cst_create_date desc) as cst_dup_rank from bronze.crm_cust_info
where cst_id is not null ) as t
where cst_dup_rank = 1; 

-- next I will check first_name shouldn't be in null lastname can be null for me

select * from bronze.crm_cust_info
where cst_firstname is not null;

-- Then we can go with Spaces check whether there is spaces or not 

select * from bronze.crm_cust_info
where trim(cst_firstname) <> cst_firstname;

-- to Over come this issue we can go with 

select trim(cst_firstname) from bronze.crm_cust_info;

-- same way follow for lastname (lastname can have null but spaces in name

select * from bronze.crm_cust_info
where trim(cst_lastname) <> cst_lastname;

select trim(cst_lastname) from bronze.crm_cust_info;

-- as we inserted the date column in date format so there is no need to update in cst_create_date

-- In Marital_status there some lower m and s and some are in upper M and S i need everything in one typo like Married, Single or not_provided

select distinct cst_marital_status from bronze.crm_cust_info;

-- below query will solve that 

select case when 
upper(trim(cst_marital_status)) = 'M' then "Married"
when upper(trim(cst_marital_status)) = 'S' then "single"
else "Not_provided" end as cst_marital_status from bronze.crm_cust_info;

-- same way I need cst_gndr in Male and Female or not_provided

select case when 
upper(trim(cst_gndr)) = 'M' then "Male"
when upper(trim(cst_gndr)) = 'F' then "Female"
else "not_provided" end as cst_gndr from bronze.crm_cust_info;



