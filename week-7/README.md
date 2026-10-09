# Week 7: Python & pandas — RFM Customer Segmentation

## Overview

This week focused on building a complete customer-level RFM (Recency, Frequency, Monetary) analysis in Python and pandas using UrbanStyle sales data.

My formally assigned group role was **Role C — RFM Analysis**. However, as a team, we decided that each member would complete **all four roles (A–D)** independently in order to practise the full workflow as much as possible.

Therefore, my artefact covers the complete analysis pipeline:

- **Role A:** Data loading and merging
- **Role B:** Data cleaning and validation
- **Role C:** RFM analysis and customer segmentation
- **Role D:** Visualization and business interpretation

Because each team member completed the full workflow independently, I kept my Week 7 artefact in a single notebook rather than separating the work into individual role folders.

## Files

```text
week-7/
├── all_roles.ipynb
├── README.md
├── Customers by RFM Segment.png
├── UrbanStyle Customer Segments (RFM).png
└── Top 10 VIP Customers by Total Spend.png
```

`all_roles.ipynb` contains the full A–D workflow.

I also exported the three final Plotly visualizations as PNG images so that the main analytical outputs can be viewed directly in the repository without opening or running the notebook.

## Analysis workflow

```text
Supabase → pandas DataFrames → merge → cleaning → RFM calculation → segmentation → Plotly visualization
```

Source tables used:

- `sales`
- `customers`

## Data preparation

The full `sales` table contained **10,118 rows**.

During validation, I found:

- **0 duplicate `invoice_id` values**
- **988 sales without `customer_id`**
- all non-null customer IDs from `sales` were found in the `customers` table

Rows without `customer_id` were excluded from the RFM analysis because customer-level behaviour cannot be calculated without identifying the customer.

The sales period in the dataset is:

**2023-01-01 to 2026-06-28**

## Reference date decision

The group-work guide suggested using a fixed reference date of `2025-02-28`.

However, the actual dataset contains transactions until **2026-06-28**. Using the suggested date would therefore produce negative Recency values for transactions occurring after February 2025.

Instead of using the fixed date, I defined the reference date dynamically as the day after the latest transaction:

```python
reference_date = df["sale_date"].max() + pd.Timedelta(days=1)
```

For this dataset, the resulting reference date is:

**2026-06-29**

This keeps Recency logically consistent and also makes the code reusable if the dataset is updated later.

## RFM methodology

For every customer I calculated:

- **Recency** — number of days since the customer's most recent purchase
- **Frequency** — number of purchases
- **Monetary** — total amount spent

Each dimension was converted into a score from 1 to 5.

For Recency, the scoring direction was reversed because a lower number of days since the last purchase represents more recent activity and should therefore receive a higher score.

For Frequency, I used `rank(method="first")` before `pd.qcut()` because many customers had identical purchase counts.

The three scores were added together to create the final RFM score.

Customer segments:

- **13–15:** VIP Champions
- **10–12:** Loyal
- **7–9:** Potential
- **4–6:** At Risk
- **3:** Lost

## Key results

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

## Visualizations

### Customers by RFM Segment

Shows the size of each customer segment, ordered from highest-value to lowest-value segment.

![Customers by RFM Segment](Customers%20by%20RFM%20Segment.png)

### UrbanStyle Customer Segments (RFM)

Scatter plot showing the relationship between:

- Recency
- Monetary value
- Frequency
- RFM segment

This makes it possible to see how customer behaviour differs across segments and highlights several very high-spending customers.

![UrbanStyle Customer Segments](UrbanStyle%20Customer%20Segments%20%28RFM%29.png)

### Top 10 VIP Customers by Total Spend

Ranks the ten highest-spending VIP Champions and shows their total historical spend.

![Top 10 VIP Customers by Total Spend](Top%2010%20VIP%20Customers%20by%20Total%20Spend.png)

## Main findings

- **Potential is the largest segment**, representing 29.9% of customers.
- **Loyal customers represent another 26.7%**, meaning more than half of the customer base is either Potential or Loyal.
- **VIP Champions account for 17.9%** of customers and represent an important retention group.
- **At-Risk customers account for 20.8%**, which is large enough to justify a targeted win-back strategy.
- A small number of customers have exceptionally high total spend, suggesting meaningful variation even within the VIP segment.

## Recommendations

1. **Protect VIP Champions** with loyalty and retention initiatives.
2. **Develop Potential customers** by encouraging additional repeat purchases.
3. **Prioritise high-value At-Risk customers** for win-back campaigns.
4. Consider more granular segmentation for exceptionally high-value VIP customers.

## Limitations

RFM describes purchase behaviour but does not explain why that behaviour occurred.

Additional data could improve the analysis, including:

- marketing campaign exposure
- returns and refunds
- product margins
- website or app behaviour
- stock availability
- customer satisfaction or NPS

## Team approach

Although roles were initially allocated across the group, we decided together that **each member would complete all four roles independently**.

The purpose was to maximise hands-on practice with the full Python and pandas workflow rather than learning only one stage of the pipeline.

My assigned role remained **Role C — RFM Analysis**, but `all_roles.ipynb` represents my complete independent practice of Roles A–D.