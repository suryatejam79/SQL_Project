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


/* From here we working on second table */

select * from bronze.crm_prd_info;
-- First thing i will do in data cleaning i will go column by column so, I'm sure nothing is going to miss
-- in the query the output first column is product id named as prd_id so, I have checked duplicates are there are not and shouldn't have null 
-- so, for checks I have used below query

select prd_id, count(*) from crm_prd_info
group by prd_id
having count(*) >1 or prd_id is null;

-- there is no null and duplicate values so I don't want to disturb first column 
-- Firstly while we clean the data we have to check is there any inter linking column for that or not if it common column we have to check which would be dim table and fact table
/* AS I have checked second column is common column for this prd_info and prd_cat and sales table table and there is slightly different as it concat of two columns of two different 
tables 
So, While working on data we must check everything is there any inter linking between tables and what columns I must use for the analysis*/
-- so, I must divide column and link to those two tables never forget to check spaces


select replace(left(prd_key, 5),'-','_') as cat_id, substring(prd_key, 7, length(prd_key)) from crm_prd_info;

-- here third column is prd_nm Here they can be duplicate but not null for as well can't have any spaces. so, i don't need any to check just can add trim

select trim(prd_nm) as prd_nm from crm_prd_info;

-- fourth column is prd_cost here i don't want any value should be in negative as there is no company in the world that gaves you product and money as  well

select distinct prd_cost from crm_prd_info
where prd_cost <0;

-- there is no negative value if there is then i will use absolute 

select abs(prd_cost) from crm_prd_info;

-- Here 5th column I have information that don't use abbrevate names like shortcuts so, I have take insight of this column shortcut values

select case
when upper(trim(prd_line)) = 'M' then 'Mountain'
when upper(trim(prd_line)) = 'S' then 'Other Sales'
when upper(trim(prd_line)) = 'T' then 'Touring'
when upper(trim(prd_line)) = 'R' then 'Road'
else 'n/a'
end as prd_line from crm_prd_info;

-- here if we look 6th and 7th column they are date column and there not a chance that end date will come first and start date comes second
-- here we can find the rows which there is typo error and we can change that

select * from crm_prd_info
where timestampdiff(day, prd_start_dt,prd_end_dt) <0 or prd_start_dt is null;

-- and I don't need format in datetime I need only date datatype as I rarely use minutes and I know that i no need here
-- so how to over come that there are many ways to over come and for me if i look prd_name repated as it is getting updated version there is mentioning it and creating prd_id 
-- so, in we have partition by prd_nm and so, it will arrange and should be order by date in ascending so, upated product will come next and that date we can mark it as end date

select date(prd_start_dt) as prd_start_dt, date_sub(date(lead(prd_start_dt) over(partition by prd_nm order by prd_start_dt)), interval 1 day) as prd_end_dt from crm_prd_info;




