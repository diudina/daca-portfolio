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
- Python for data analysis
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

## Tools

- PostgreSQL
- Supabase
- SQL
- Tableau Public
- Git & GitHub
- VS Code
- CSV
- Python — introduced later in the programme

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

## AI Use

AI is used as a learning and analytical support tool throughout the programme.

I use it to:

- clarify unfamiliar concepts
- review analytical logic
- troubleshoot tools
- explore alternative approaches
- improve documentation and communication

I still validate calculations, choose metric definitions, make analytical decisions, and review the final interpretation myself.

## Repository

This repository documents my work throughout the **DACA Data Analyst Career Accelerator**, including SQL exercises, data-quality investigations, stakeholder analyses, dashboards and portfolio artefacts.

The goal is not only to demonstrate tool usage, but to show the development of a structured analytical process: from business question to validated data, analysis, interpretation and communication.