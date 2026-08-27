-- ============================================================
-- DACA Data Analyst Career Accelerator
-- Week 1 — SQL Fundamentals
-- Role A: Sales Transaction Explorer
--
-- Purpose:
-- Explore the UrbanStyle sales table with a focus on transaction
-- volume, dates, amounts, customer linkage and potential
-- data-quality issues.
--
-- Week 1 scope:
-- Read-only exploration. No source data is modified.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Dataset size
-- Business question:
-- How many transaction rows are available in the sales table?
-- ------------------------------------------------------------

SELECT COUNT(*) AS row_count
FROM sales;


-- ------------------------------------------------------------
-- 2. Customer linkage
-- Business question:
-- How complete is the customer_id field and how many identified
-- customers appear in the sales data?
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS all_rows,
    COUNT(customer_id) AS rows_with_customer,
    COUNT(*) - COUNT(customer_id) AS missing_customer_ids,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales;


-- ------------------------------------------------------------
-- 3. Transaction value range
-- Business question:
-- What are the largest and smallest recorded transaction values?
-- ------------------------------------------------------------

-- Largest transactions
SELECT
    sale_id,
    customer_id,
    sale_date,
    total_price
FROM sales
ORDER BY total_price DESC
LIMIT 10;


-- Smallest transactions
SELECT
    sale_id,
    customer_id,
    sale_date,
    total_price
FROM sales
ORDER BY total_price ASC
LIMIT 10;


-- ------------------------------------------------------------
-- 4. Negative transactions
-- Business question:
-- How many sales records have a negative total price?
--
-- Week 1 finding:
-- 305 rows have a negative total_price.
-- Their business meaning is not defined in the available data,
-- so they should not automatically be classified as refunds,
-- returns or errors.
-- ------------------------------------------------------------

SELECT COUNT(*) AS negative_transactions
FROM sales
WHERE total_price < 0;


-- Inspect a sample of negative transactions
SELECT
    sale_id,
    customer_id,
    sale_date,
    quantity,
    total_price
FROM sales
WHERE total_price < 0
ORDER BY total_price ASC
LIMIT 20;


-- ------------------------------------------------------------
-- 5. Date coverage
-- Business question:
-- What time period does the sales table cover?
--
-- Observed range:
-- 2023-01-01 to 2026-06-28
-- ------------------------------------------------------------

-- Earliest transaction
SELECT *
FROM sales
ORDER BY sale_date ASC
LIMIT 1;

-- Most recent transactions
SELECT
    customer_id,
    sale_date,
    total_price
FROM sales
ORDER BY sale_date DESC
LIMIT 20;


-- ------------------------------------------------------------
-- 6. Potential repeated sale identifiers
-- Business question:
-- Does the number of rows differ from the number of distinct
-- sale_id values?
--
-- A difference indicates repeated identifiers but does not
-- establish why they repeat.
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS all_rows,
    COUNT(DISTINCT sale_id) AS unique_sale_ids
FROM sales;


-- Rows worth further inspection:
-- missing customer link OR non-positive transaction value
SELECT *
FROM sales
WHERE customer_id IS NULL
   OR total_price <= 0;
