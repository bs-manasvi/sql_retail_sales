DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
               (
                 transactions_id INT PRIMARY KEY,
                 sale_date DATE,
                 sale_time TIME,
                 customer_id INT,
                 gender VARCHAR(15),
                 age INT,
                 category VARCHAR(15),
                 quantity INT,
                 price_per_unit FLOAT,	
                 cogs FLOAT,
                 total_sale FLOAT
               );


SELECT * FROM retail_sales
LIMIT 10;

SELECT 
COUNT(*) 
FROM retail_sales;



SELECT * FROM retail_sales
WHERE transactions_id is NULL;

SELECT * FROM retail_sales
WHERE sale_time is NULL
OR transactions_id is NULL
OR sale_time is NULL
OR gender is NULL
OR category is NULL
Or quantity is NULL
Or cogs is NULL;

DELETE FROM retail_sales
WHERE sale_time is NULL
OR transactions_id is NULL
OR sale_time is NULL
OR gender is NULL
OR category is NULL
Or quantity is NULL
Or cogs is NULL;

--how many sales we have
SELECT COUNT(*) as total_sale FROM retail_sales

--How many unique customers we have

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

--How many unique category we have
SELECT DISTINCT category FROM retail_sales


--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date ='2022-11-05'

--Q2.Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more tahn 4 in the month of 'Nov-2022'
SELECT *
FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND quantity>=4


--Q3.Write a SQL query to calculate the total sales (total_sales) for each category.
SELECT category,
SUM(total_sale) as net_sales,
COUNT(*) as total_orders
from retail_sales
GROUP BY category

--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category='Beauty'

--Q5.Write a SQL query to find all the transactions wherethe total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale>1000

--Q6.Write SQL query to find the total number of transactions (transactions_id) made by each gender in each company
SELECT category,
gender,
COUNT(*)
FROM retail_sales
GROUP BY category , gender

--Q7.Write a SQL query to calculate the average sale for each month. find out best selling month in each year.
SELECT * FROM 
(
SELECT EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,3 DESC
) as t1
WHERE rank=1


--Q8.Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
customer_id,
SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5


--Q9. Write a SQL query tofind the number of unique customers who purchased items from each category.
SELECT
category,
COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY 1

--Q10.Write a SQL query to create each shift and number of orders (Example Warning<12, afternoon between 12 & 17, Evening>17)
WITH hourly_sale
AS
(
SELECT * ,
    CASE
	    WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
shift,
COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift