--check the records
select * from retail_sales
limit 10

--number of record 
select count(*) from retail_sales

--------------------------------
--            DATA CLEANING
-------------------------------

--check if there is  null value
select * from retail_sales 
where
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null
-- delete those row
delete from retail_sales 
where
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null

-------------------------------------
--            DATA EXPLORATION
-------------------------------------

--how many sales we have
select count(*) as total_sale
from retail_Sales

--how many unique customers we have
select count(distinct customer_id) as unique_customer
from retail_sales

--how many unique category we have
select count(distinct category) as unique_category
from retail_sales

--what are those category
select distinct category as unique_category
from retail_sales

-----------------------------------------------
--           DATA ANALYSIS/ BUSINESS PROBLEM
-----------------------------------------------

--retrive all columns for sales made on '2022-11-05'
select * from retail_sales
where
sale_date = '2022-11-05'

--retrive  all transaction where the category is 
--'clothing and quantity sold is more than or equal to 4 in the month of nov-2022'
select * from retail_sales
where
category = 'Clothing'
and
quantiy >= '4'
and
to_char(sale_date, 'yyyy-mm') = '2022-11'
  
--calculate the totla sales (total_sale) for each category
--find  average age of customers who purchaseditems from 'beauty' category
select
round(avg(age), 2) as average_age
from retail_sales
where category = 'Beauty'

--calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale) as sum_Sale,
count(*) as total_order
from retail_sales
group by 1

--find all transaction where the total_sales is grater than 1000
select * from retail_Sales
where total_Sale > 1000

--total number of transactions (transaction_id) made by each gender in each category
select 
category,
gender,
count (transactions_id) as transactions_made_by_each_gender
from retail_Sales
group by category,gender
order by 1

--calcuate average sale for each month. find out best selling month in each year
select 
to_char(sale_date, 'yyyy-mm' ) ,
avg(total_sale) as average_sale
from retail_sales
group by 1
order  by 2 desc
-- OR
select
extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as average_sale,
rank() over(partition by extract (year from sale_Date) order by avg(total_sale) desc)
from retail_Sales
group by 1, 2

-- for the above problem to retrive  just only the best selling month
select
year,
month,
average_sale
from
(
select
extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as average_sale,
rank() over(partition by extract (year from sale_Date) order by avg(total_sale) desc)
from retail_Sales
group by 1, 2
)as t1
where 
rank = 1

--find top 5 costomers based on highest totla sale
select
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5 

--find the number of unique costomers who purchased item from each category.
select
category,
count (distinct customer_id) as unique_customers
from retail_sales
group by 1

--create each shift and number of orders (example moring <=12, afternoon between 12 & 17, evening > 17)
select *,
case 
  when extract (hour from sale_time) < 12 then 'morning'
  when extract(hour from sale_time) between 12 and 17 then 'afternoon'
  when extract(hour from sale_time) > 17 then 'evening'
  else 'null'
  end as shift
from retail_sales

--number of order in each shift
with hourly_sale
as
(
select *,
case 
  when extract (hour from sale_time) < 12 then 'morning'
  when extract(hour from sale_time) between 12 and 17 then 'afternoon'
  when extract(hour from sale_time) > 17 then 'evening'
  else 'null'
  end as shift
from retail_sales
)
select 
  shift,
  count(*) as total_order
from hourly_sale
group by shift


