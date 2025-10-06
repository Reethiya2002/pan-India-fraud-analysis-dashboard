use [customer segmentation]

---rename
exec sp_rename panindiandataset,panindian

----select 10 rows 
SELECT TOP 10 * FROM panindian

---check number of rows 
SELECT COUNT(*) AS total_rows FROM panindian --output(10267)

--- check for missing values

SELECT
    SUM(CASE WHEN trans_id IS NULL THEN 1 ELSE 0 END) AS missing_trans_id,        ----649
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,    
    SUM(CASE WHEN first IS NULL THEN 1 ELSE 0 END) AS missing_first_name,
    SUM(CASE WHEN last IS NULL THEN 1 ELSE 0 END) AS missing_last_name,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS missing_state,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN trans_date_trans_time IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN amt IS NULL THEN 1 ELSE 0 END) AS missing_amount
FROM panindian;

---handling missing values 

DELETE FROM panindian
WHERE customer_id IS NULL OR trans_id IS NULL;

---tex column

UPDATE panindian
SET first = 'Unknown' WHERE first IS NULL;
UPDATE panindian
SET last = 'Unknown' WHERE last IS NULL;
UPDATE panindian
SET gender = 'Unknown' WHERE gender IS NULL;
UPDATE panindian
SET city = 'Unknown' WHERE city IS NULL;
UPDATE panindian
SET state = 'Unknown' WHERE state IS NULL;
UPDATE panindian
SET category = 'Unknown' WHERE category IS NULL;

--- set amount 0

-- Option 1: fill with 0
UPDATE panindian
SET amt = 0
WHERE amt IS NULL;


----missing date

DELETE FROM panindian
WHERE trans_date_trans_time IS NULL;

---check duplicates

SELECT trans_id, COUNT(*) AS count_duplicates
FROM panindian
GROUP BY trans_id
HAVING COUNT(*) > 1;

----remove duplicate transcation

WITH CTE_Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY trans_id ORDER BY trans_date_trans_time) AS rn
    FROM panindian
)
DELETE FROM CTE_Duplicates
WHERE rn > 1;

---total transcation per state

SELECT state, COUNT(*) AS total_transactions
FROM panindian
GROUP BY state
ORDER BY total_transactions DESC;

--- top 5 product category

SELECT TOP 5 category, COUNT(*) AS total_transactions
FROM panindian
GROUP BY category
ORDER BY total_transactions DESC;

---Gender distribution

SELECT gender, COUNT(*) AS total_transactions
FROM panindian
GROUP BY gender;

---Monthly sales trend

SELECT 
    FORMAT(trans_date_trans_time, 'yyyy-MM') AS month,
    SUM(amt) AS total_amount
FROM panindian
GROUP BY FORMAT(trans_date_trans_time, 'yyyy-MM')
ORDER BY month;

----Total panindian & Amounts

-- Total transactions
SELECT COUNT(*) AS total_transactions FROM panindian  ---result 473

-- Total sales amount
SELECT SUM(amt) AS total_sales FROM panindian    ----2312016.68


---Transactions by State

SELECT state, 
       COUNT(*) AS total_transactions, 
       SUM(amt) AS total_sales
FROM panindian
GROUP BY state
ORDER BY total_sales DESC;

----Transactions by City

SELECT city, 
       COUNT(*) AS total_transactions, 
       SUM(amt) AS total_sales
FROM panindian
GROUP BY city
ORDER BY total_sales DESC;

---Transactions by Gender

SELECT gender, 
       COUNT(*) AS total_transactions, 
       SUM(amt) AS total_sales
FROM panindian
GROUP BY gender;

---Transactions by Product Category

SELECT category, 
       COUNT(*) AS total_transactions, 
       SUM(amt) AS total_sales
FROM panindian
GROUP BY category
ORDER BY total_sales DESC;

---Monthly / Yearly Sales Trend

-- Monthly
SELECT FORMAT(trans_date_trans_time,'yyyy-MM') AS month, 
       COUNT(*) AS total_transactions,
       SUM(amt) AS total_sales
FROM panindian
GROUP BY FORMAT(trans_date_trans_time,'yyyy-MM')
ORDER BY month;

-- Yearly
SELECT YEAR(trans_date_trans_time) AS year, 
       COUNT(*) AS total_transactions,
       SUM(amt) AS total_sales
FROM panindian
GROUP BY YEAR(trans_date_trans_time)
ORDER BY year;

---Top Customers by Spending

SELECT customer_id, 
       COUNT(*) AS transactions_count, 
       SUM(amt) AS total_spent
FROM panindian
GROUP BY customer_id
ORDER BY total_spent DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

----Average Transaction Amount

SELECT AVG(amt) AS avg_transaction_amount FROM panindian;

---dimension method 

SELECT state,category,gender,              -- example: state, category, gender
       COUNT(*) AS total_transactions,
       SUM(amt) AS total_sales
FROM panindian
GROUP BY state,category,gender
ORDER BY total_sales DESC;

----Sales Trend Over Time

SELECT 
    CAST(trans_date_trans_time AS date) AS transaction_date,
    COUNT(*) AS total_transactions,
    SUM(amt) AS total_sales
FROM panindian
GROUP BY CAST(trans_date_trans_time AS date)
ORDER BY transaction_date;


SELECT*FROM panindian;
----Replace NULLs with a default value

-- For text columns
UPDATE panindian
SET job = 'Unknown'
WHERE job IS NULL;

UPDATE panindian
SET street = 'Unknown'
WHERE street IS NULL;

-- For numeric columns
UPDATE panindian
SET city_pop = 0
WHERE city_pop IS NULL;

UPDATE panindian
SET long = 0
WHERE long IS NULL;

--- remove row is null

DELETE FROM panindian
WHERE is_fraud IS NULL OR dob IS NULL;

--- check my data again 
SELECT
    SUM(CASE WHEN is_fraud IS NULL THEN 1 ELSE 0 END) AS missing_is_fraud,
    SUM(CASE WHEN merch_long IS NULL THEN 1 ELSE 0 END) AS missing_merch_long,
    SUM(CASE WHEN dob IS NULL THEN 1 ELSE 0 END) AS missing_dob,
    SUM(CASE WHEN job IS NULL THEN 1 ELSE 0 END) AS missing_job,
    SUM(CASE WHEN city_pop IS NULL THEN 1 ELSE 0 END) AS missing_city_pop,
    SUM(CASE WHEN long IS NULL THEN 1 ELSE 0 END) AS missing_long,
    SUM(CASE WHEN last IS NULL THEN 1 ELSE 0 END) AS missing_last,
    SUM(CASE WHEN street IS NULL THEN 1 ELSE 0 END) AS missing_street
FROM panindian;

---fix null values 
UPDATE panindian
SET merch_long = 0
WHERE merch_long IS NULL;


update panindian
set merch_lat = 0
where merch_lat is null

update panindian
set lat =0
where lat is null

update panindian
set merchant = 'Unknown'
where merchant is null






























