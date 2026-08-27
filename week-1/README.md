# Week 1 — SQL Fundamentals and Data Exploration

## Overview

Week 1 focused on using SQL to explore the first UrbanStyle dataset and establish a reliable baseline before performing more complex analysis or data cleaning.

During the group session, I worked as **Role A — Sales Transaction Explorer** and investigated the `sales` table, focusing on transaction amounts, dates, customer linkage and potential data-quality issues.

## Data Used

Week 1 UrbanStyle tables:

- `sales`
- `customers`
- `products`

My individual analysis focused on `sales`.

## Method

I used read-only SQL queries including:

- `SELECT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `DISTINCT`
- `COUNT`
- `COUNT(DISTINCT ...)`
- `IS NULL`

My queries are available in:

[`individual/week1_sales_exploration.sql`](individual/week1_sales_exploration.sql)

## Key Findings

The `sales` table contains **15,234 transaction rows** covering the period from **1 January 2023 to 28 June 2026**.

Transaction values range from **−€1,405.32 to €2,170.40**.

### Sale ID uniqueness

The `sales` table contains **15,234 rows but only 10,118 distinct
`sale_id` values**.

This means that `sale_id` is not unique at row level. However, repeated
sale IDs should not automatically be treated as duplicate records:
multiple rows may potentially belong to the same business transaction.

The structure and business definition of a sale should therefore be
confirmed before any duplicate-removal logic is applied.

### Missing customer IDs

- Transactions with a customer ID: **13,747**
- Transactions without a customer ID: **1,487**
- Missing customer ID rate: **9.8%**
- Unique identified customers: **2,558**

Transactions without a customer ID cannot be directly linked to an individual customer. However, this does not necessarily indicate an error, as the available data does not explain whether anonymous or guest transactions are expected.

### Negative transaction values

I identified **305 transactions (approximately 2.0%)** with a negative `total_price`.

The available Week 1 data does not establish what these transactions represent. They could potentially relate to refunds, returns, corrections or another business process, but this requires clarification before making that conclusion.

## Interpretation

The sales dataset is suitable for initial exploration, but some business definitions need to be clarified before using it for revenue or customer-level reporting.

In particular:

1. The meaning of negative transactions should be established before calculating or interpreting revenue.
2. The reason for missing customer IDs should be understood before drawing conclusions from customer-level sales analysis.
3. Repeated identifiers should be treated as an investigation signal rather than automatically classified as erroneous duplicates.

## Evidence

A screenshot of the SQL results is available here:

[`individual/week1_results_screenshot.png`](individual/week1_results_screenshot.png)

## Team Work

Our Customer Insights team divided the Week 1 exploration into four domains:

- Sales transactions
- Customers
- Products
- Sales channels and locations

The individual findings were combined into a shared Week 1 data-quality investigation.

See:

[`team/week1_data_landscape.md`](team/week1_data_landscape.md)

## Reflection

The main learning from this week was not the SQL syntax itself, but the distinction between identifying an unusual pattern and explaining its cause.

A query can show that a value is missing, negative or repeated, but the result alone does not explain why. Business definitions and source-process knowledge are required before deciding whether such records represent valid business activity or a data-quality problem.