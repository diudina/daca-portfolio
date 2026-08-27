# Week 1 — Customer Insights Data Landscape

**Team:** Customer Insights  
**Week:** 1  
**Stakeholder:** Toomas Kask, IT Director  
**Topic:** UrbanStyle Data Quality Investigation

## Challenge

Toomas Kask asked the team to establish what is actually contained in the Week 1 UrbanStyle data before using it for further analysis.

The team divided the investigation into four data domains:

- **Role A — Sales transactions:** Daria Iudina
- **Role B — Customer data:** Reio Lootsmann
- **Role C — Product catalogue:** Maria
- **Role D — Sales channels and locations:** Marvis Nelson

The analysis used read-only Week 1 SQL methods. No source data was modified.

---

## Data Landscape

### Sales Transactions

The `sales` table contains **15,234 rows** covering **January 2023 to
June 2026**, but only **10,118 distinct `sale_id` values**.

This indicates that `sale_id` is not unique at row level. The repeated
identifiers should not yet be classified as duplicate records, because
the available Week 1 data does not establish whether multiple rows may
legitimately belong to the same sale.

Additional findings:

- **1,487 transactions (9.8%)** have no customer ID.
- **305 rows (approximately 2.0%)** have a negative `total_price`.
- Recorded transaction values range from **−€1,405.32 to €2,170.40**.

Transactions without customer IDs cannot be directly linked to identified customers.

The business meaning of the negative transactions is not available in the Week 1 data. They may potentially represent returns, refunds, corrections or another business process, but this cannot yet be concluded from the data alone.

---

### Customers

The `customers` table contains **3,150 customer records**.

Data completeness findings:

- Missing first names: **0**
- Missing emails: **380 (12%)**
- Registration period: **January 2020 to February 2025**

The most significant issue was the `city` field.

The dataset contains **54 different city values for what appears to represent roughly a dozen actual cities**. Tallinn alone appears in at least four variants caused by differences in casing and whitespace.

This creates a significant reporting risk because grouping customers by the raw `city` field could silently split the same city into several categories and undercount it without generating a SQL error.

---

### Products

The `products` table contains **362 products across five distinct categories**.

Recorded retail prices range from **€13.53 to €434.08**.

No missing values were found in:

- `retail_price`
- `category`

The product data therefore appears complete enough for basic price and category exploration. This does not prove that the entire products table is free from data-quality issues.

---

### Sales Channels and Locations

The sales data contains two recorded sales channels:

- Online
- Shop

Physical store locations identified:

- Tallinn
- Pärnu
- Tartu

A `NULL` store-location value also occurs.

Payment methods identified include:

- Cash
- Card
- Installments

The analysis found **10,408 transactions without a recorded store location**.

The team also observed that online transactions showed a consistent quantity value of **5**, which requires further business clarification before being interpreted.

---

## Patterns Across the Dataset

### Gaps rather than broken relationships

The team found no orphaned customer foreign-key relationships.

The main completeness gaps occur in optional or nullable fields, including:

- customer ID
- store location
- customer email

### Free-text values need standardisation

The customer `city` field demonstrates the risk of unrestricted free-text entry.

Multiple spellings, casing differences and whitespace variations can cause logically identical categories to be treated as separate values during analysis.

### Some patterns require business context

SQL can identify patterns such as:

- negative transaction values
- missing store locations
- repeated identifiers
- constant online quantities

However, the available data alone cannot establish their business meaning.

---

## Biggest Surprise

One of the strongest data-quality findings was the customer `city` field: **54 recorded variants appear to represent roughly a dozen actual cities**.

This type of issue can silently distort location-based reporting because SQL still returns valid-looking results while logically identical locations are counted separately.

---

## Recommendation for Toomas

Before using the dataset for decision-critical reporting, UrbanStyle should establish clear validation and standardisation rules for important business fields.

In particular, the team recommends:

- standardising customer city values before location-based reporting;
- clarifying the meaning of negative sales transactions;
- confirming the expected meaning of missing store locations and customer IDs;
- agreeing on the definition that should be used when identifying duplicate sales.

---

## Missing Data and Business Definitions

The Week 1 analysis identified several questions that cannot be answered from the available tables alone.

We are missing business definitions or metadata explaining:

1. Whether negative-price transactions represent returns, refunds, corrections or errors.
2. Whether a `NULL` store location is expected for particular transaction types or represents missing information.
3. What canonical city values should be used for customer-location reporting.
4. What business definition should be used to determine whether repeated sale identifiers represent duplicates.
5. Why online transactions show a consistent quantity of 5.

---

## Main Conclusion

The UrbanStyle data provides a usable baseline for exploration, but several fields require validation or business definitions before they should be used in headline reporting.

## Decision Impact

The team would avoid making decision-critical revenue, customer-location or duplicate-related conclusions until the identified data-quality questions have been clarified.

## Next Step

Preserve the raw evidence, document the validation questions and agree on business rules before applying cleaning or transformation logic.