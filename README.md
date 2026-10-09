# DACA Portfolio — Daria Iudina

## About me

I am a former software developer with experience in full-stack development, frontend engineering, and UI/UX design, now transitioning into data analytics with a particular interest in **Product Analytics**.

My technical background taught me how to investigate complex systems, trace problems back to their source, work with structured data, and translate ambiguous requirements into practical solutions.

In analytics, I am especially interested in understanding **why metrics change, how user and business behaviour can be measured, and how data can support product decisions**.

## Goal

My goal during the DACA programme is to build practical experience in:

- SQL and relational databases
- Data exploration and data quality
- Data cleaning and validation
- Analytical problem-solving
- Product and business metrics
- Aggregation and window functions
- Data visualisation and dashboard design
- Python and pandas for data analysis
- Customer segmentation
- Communicating findings and recommendations

Alongside the technical tools, I am developing a structured analytical approach:

1. Define the business question
2. Understand the grain and structure of the data
3. Validate the source data before analysis
4. Choose metrics that match the question
5. Analyse patterns and differences
6. Separate observations from assumptions
7. Communicate findings in a way that supports a decision

## Weekly Work

| Week | Topic | Main focus | Status |
|---|---|---|---|
| 0 | Onboarding & working environment | Git, GitHub, VS Code, PostgreSQL/Supabase setup | Completed |
| 1 | SQL Fundamentals | SELECT, filtering, exploration, basic data-quality checks | Completed |
| 2 | SQL & Data Cleaning | NULLs, duplicates, standardisation, customer-data cleaning | Completed |
| 3 | JOINs & Relational Analysis | Multi-table analysis, products, inventory, sales relationships | Completed |
| 4 | SQL Aggregation | GROUP BY, HAVING, CTEs, window functions, marketing attribution | Completed |
| 5 | Visualisation Design | Tableau dashboard design, KPIs, trends, business interpretation | Completed |
| 6 | Data Storytelling | Tableau storytelling, location-level analysis, team synthesis | Completed |
| 7 | Python & pandas | Data loading, cleaning, RFM segmentation, Plotly visualisation | Completed |

## Selected Work

### Week 1 — Sales Data Exploration

Explored the UrbanStyle sales dataset and identified several data-quality issues, including:

- missing customer IDs
- negative transaction values
- repeated sale IDs
- wide transaction-value ranges

This week focused on learning how to move from basic SQL queries to structured data exploration.

### Week 2 — Customer Data Cleaning

Analysed customer-data quality and worked with:

- duplicate email values
- missing email addresses
- inconsistent city names
- text standardisation using `TRIM()`, `LOWER()` and `INITCAP()`

A key lesson was that a duplicated field does not automatically mean a duplicated customer, so deletion rules need to be based on multiple attributes rather than one column alone.

### Week 3 — Products & Inventory Analysis

Used joins across sales, products and inventory to investigate product performance and stock availability.

Findings included:

- products that had never been sold
- products missing from inventory
- revenue differences across product categories
- inventory records at or below reorder level
- negative inventory quantities requiring investigation

This week reinforced the importance of understanding table relationships before interpreting joined results.

### Week 4 — Marketing Channel Effectiveness & Attribution

Analysed marketing-channel effectiveness using `sales` and `web_logs`.

The original task query introduced a **fan-out join** by connecting sales directly to multiple web-log rows per customer, which inflated revenue.

I rebuilt the analysis using a last-touch attribution approach:

- standardised inconsistent traffic-source names
- reduced page views to one dominant source per session
- matched sessions to customers
- attributed each sale to the latest known session before the purchase
- retained unmatched sales as `unattributed`
- validated the final result against the sales source of truth

Final reconciliation:

- **10,118 orders**
- **€2.91M revenue**
- **69.3% of revenue attributed to a known web source**
- **30.7% unattributed**

This exercise was especially useful for learning about **data grain, join fan-out, attribution assumptions and reconciliation**.

### Week 5 — CEO Dashboard in Tableau

Built a CEO dashboard answering:

**Is UrbanStyle growing?**

The dashboard includes:

- Total Revenue
- Registered Customers
- Revenue Growth %
- Monthly Revenue Trend

Key result:

**Revenue increased by 19.1% from 2023 to 2024, from approximately €1.23M to €1.47M.**

The monthly pattern was uneven, so the conclusion was based on the comparison between the two complete years rather than assuming continuous month-to-month growth.

This week focused on:

- selecting appropriate chart types
- KPI design
- visual hierarchy
- dashboard layout
- business interpretation
- communicating results for a stakeholder

### Week 6 — Tartu Store Performance Story

Built a focused Tableau story for the Tartu store, comparing 2024 performance with 2023.

The task scenario suggested that Tartu was declining, but validation of the actual data showed the opposite.

Key findings:

- **2024 revenue: €260K**
- **Revenue growth: +13% YoY**
- **Orders: +16%**
- **Purchasing customers: +18%**
- **Average Order Value: -3%**

This suggested that growth was primarily **volume-driven**: more customers and more orders, rather than higher spend per order.

Monthly performance was volatile:

- April: **-31% YoY**
- May: **+97% YoY**
- December: strongest month at approximately **€33K**

This week reinforced the importance of:

- validating the scenario before building the story
- distinguishing volume growth from value growth
- using annotations and reference lines deliberately
- presenting findings without forcing the data to match an expected narrative

### Week 7 — RFM Customer Segmentation in Python & pandas

Built an end-to-end RFM (Recency, Frequency, Monetary) customer segmentation workflow using Python, pandas, Supabase and Plotly.

My formally assigned role was **Role C — RFM Analysis**, but our team agreed that every member would complete **all four roles independently** in order to practise the full workflow as much as possible.

My Week 7 artefact therefore includes:

- **Role A:** data loading and merging
- **Role B:** data cleaning and validation
- **Role C:** RFM calculation and customer segmentation
- **Role D:** Plotly visualisation and business interpretation

The full `sales` table contained **10,118 rows**.

During validation:

- **0 duplicate `invoice_id` values** were found
- **988 sales without `customer_id`** were identified
- all non-null customer IDs in `sales` were found in `customers`

Rows without `customer_id` were excluded from the RFM analysis because customer-level behaviour cannot be calculated without identifying the customer.

The dataset covers:

**2023-01-01 to 2026-06-28**

The group-work guide suggested a fixed RFM reference date of `2025-02-28`, but this would create negative Recency values because the dataset contains later transactions.

Instead, I used a dynamic reference date:

```python
reference_date = df["sale_date"].max() + pd.Timedelta(days=1)
```

For this dataset:

**Reference date = 2026-06-29**

The final RFM dataset contained **2,540 customers**.

| Segment | Customers | Share |
|---|---:|---:|
| Potential | 759 | 29.9% |
| Loyal | 679 | 26.7% |
| At Risk | 529 | 20.8% |
| VIP Champions | 455 | 17.9% |
| Lost | 118 | 4.6% |

Observed ranges:

- Recency: **1–1,269 days**
- Frequency: **1–77 purchases**
- Monetary: **€15.09–€27,920.86**

Key findings:

- **Potential is the largest segment** at 29.9%.
- **Loyal customers represent another 26.7%**, so more than half of the customer base is either Potential or Loyal.
- **VIP Champions account for 17.9%** and represent an important retention group.
- **At-Risk customers account for 20.8%**, large enough to justify a dedicated win-back strategy.
- A small number of customers have exceptionally high spend, suggesting meaningful variation even within the VIP segment.

The final artefact includes three Plotly visualisations:

- Customers by RFM Segment
- UrbanStyle Customer Segments — Recency vs Monetary
- Top 10 VIP Customers by Total Spend

This week was my first complete Python analysis workflow and helped connect concepts I already knew from SQL with their pandas equivalents:

- `WHERE` → boolean filtering
- `GROUP BY` → `groupby()`
- `JOIN` → `merge()`
- customer-level aggregation → RFM analysis

## Tools

- PostgreSQL
- Supabase
- SQL
- Python
- pandas
- Plotly
- Tableau Public
- Jupyter Notebook
- Git & GitHub
- VS Code
- CSV

## Analytical Principles

A few principles I am deliberately practising throughout the programme:

- **Validate totals before interpreting them**
- **Check the grain before joining tables**
- **Do not treat correlation or attribution as causation**
- **Name metrics precisely**
- **Make assumptions explicit**
- **Separate findings from explanations**
- **Prefer evidence over intuition**
- **Design analysis around the decision it needs to support**
- **Challenge task assumptions when they conflict with the data**
- **Make analytical choices reproducible where possible**

## AI Use

AI is used as a learning and analytical support tool throughout the programme.

I use it to:

- clarify unfamiliar concepts
- review analytical logic
- troubleshoot tools
- explore alternative approaches
- improve documentation and communication
- explain unfamiliar Python and pandas syntax

I still validate calculations, choose metric definitions, make analytical decisions, and review the final interpretation myself.

For Week 7 specifically, AI helped me understand and debug:

- Supabase API row limits
- pandas `groupby()`
- RFM scoring
- `pd.qcut()`
- Frequency ranking before quintile assignment
- Plotly chart formatting and readability

## Repository

This repository documents my work throughout the **DACA Data Analyst Career Accelerator**, including SQL exercises, data-quality investigations, stakeholder analyses, dashboards, Python notebooks and portfolio artefacts.

The goal is not only to demonstrate tool usage, but to show the development of a structured analytical process:

**business question → validated data → analysis → interpretation → decision support**