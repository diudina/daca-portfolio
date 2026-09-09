# Week 2 — Customer Data Cleaning Report

## Dataset
Table: `customers_test`  
Total customer records: **3,150**

## Issues identified before cleaning

- **128 duplicate email values** were associated with multiple customer records.
- **380 customers (12.1%)** had no email address.
- **0 missing first names**.
- **0 missing last names**.
- **0 missing phone numbers**.
- City data contained **54 distinct original values representing 12 actual cities**, caused by inconsistent capitalisation and whitespace.

## Cleaning performed

City names were standardised using:

`INITCAP(TRIM(city))`

Existing email addresses were standardised using:

`LOWER(TRIM(email))`

Missing email addresses were intentionally left as `NULL`, because the correct values are unknown and should not be invented.

Duplicate email records were not deleted automatically because a shared email address alone does not prove that two customer records represent the same customer.

## Recommendation

Use the standardised city and email values for further analysis. Missing email addresses should remain flagged for collection rather than replaced with artificial values. Duplicate-email customer records require additional business validation before merging or deleting any records.