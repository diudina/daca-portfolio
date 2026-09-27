# Week 4 — SQL Aggregation

## Marketing Channel Effectiveness & Attribution

For Week 4, I worked on a marketing-channel analysis using `sales` and `web_logs`.

The original task was framed as campaign ROI analysis, but the available dataset did not contain marketing spend or campaign-cost data. Therefore, the analysis can measure **channel effectiveness and attributed revenue**, but not true ROI.

## Business question

Which marketing channels are associated with the highest revenue and customer value, and how does channel performance change over time?

## Data-quality issue discovered

The original course query joined `sales` directly to `web_logs` using `customer_id`.

This created a **fan-out problem** because one customer can have many web-log rows. As a result, a single sale could be repeated multiple times after the join, artificially inflating revenue.

Because there was no direct `sale_id → session_id` relationship in the data, channel attribution required an explicit attribution rule rather than a simple join.

## Validation

Before attribution, I established the sales source of truth:

- **Orders:** 10,118
- **Total revenue:** €2,909,177.98

The final attributed dataset reconciled back to exactly the same totals.

This validation was essential because an attribution model should redistribute existing revenue across channels, not create additional revenue.

## Attribution approach

I used a last-touch attribution model.

### 1. Standardise traffic sources

The raw `web_logs.source` field contained multiple naming variants for the same source.

Examples included:

- `Facebook`, `FB` → `facebook`
- `Facebook Ads`, `facebook_ads`, `fb_ads` → `facebook_ads`
- `google`, `Google`, `google organic`, `Google Organic`, `google_organic` → `google`
- `google_ads` → `google_ads`
- `IG`, `instagram`, `Instagram` → `instagram`
- `ig_ads`, `instagram_ads` → `instagram_ads`

The final analysis used nine standardised sources:

- direct
- email_campaign
- facebook
- facebook_ads
- google
- google_ads
- instagram
- instagram_ads
- tiktok

### 2. Reduce page views to one source per session

A session could contain multiple web-log rows and sometimes multiple source values.

I counted source occurrences within each session and selected the most frequently occurring source as the session's dominant source.

This reduced the web-log data to one attributable source per session.

### 3. Match sessions to customers

For each session, I retained the customer ID where available.

Anonymous sessions could not be reliably linked to a later sale.

### 4. Last-touch attribution

For each sale, I searched for sessions belonging to the same customer where:

`visit_date <= sale_date`

I then selected the latest qualifying session before the sale.

If no qualifying session existed, the sale was retained as:

`unattributed`

This ensured that no real sales were dropped simply because a marketing source could not be identified.

## Results

| Channel | Orders | Revenue |
|---|---:|---:|
| Unattributed | 3,054 | €893,781.80 |
| Google | 2,088 | €602,611.99 |
| Direct | 1,258 | €346,580.04 |
| Facebook Ads | 1,175 | €332,978.90 |
| Email Campaign | 832 | €242,639.78 |
| Instagram | 819 | €239,831.93 |
| Google Ads | 499 | €145,797.69 |
| TikTok | 351 | €92,337.57 |
| Facebook | 38 | €11,905.93 |
| Instagram Ads | 4 | €712.35 |

Total:

- **10,118 orders**
- **€2,909,177.98 revenue**

### Attribution coverage

- **Attributed revenue:** €2,015,396.18 — **69.3%**
- **Unattributed revenue:** €893,781.80 — **30.7%**

This means the attribution rule could identify a prior known web source for approximately 69% of revenue.

The remaining 31% of revenue is real sales revenue, but the available data does not provide enough information to assign it confidently to a channel.

## Channel effectiveness

Among channels with more than 100 attributed orders:

| Channel | Orders | Unique customers | Revenue | Revenue per customer |
|---|---:|---:|---:|---:|
| Email Campaign | 832 | 360 | €242,639.78 | €674.00 |
| Google | 2,088 | 958 | €602,611.99 | €629.03 |
| Facebook Ads | 1,175 | 537 | €332,978.90 | €620.07 |
| Instagram | 819 | 402 | €239,831.93 | €596.60 |
| Google Ads | 499 | 260 | €145,797.69 | €560.76 |
| Direct | 1,258 | 626 | €346,580.04 | €553.64 |
| TikTok | 351 | 194 | €92,337.57 | €475.97 |

Google produced the largest amount of attributable revenue and the largest attributed customer base.

Email campaigns produced the highest attributed revenue per customer among channels with more than 100 orders.

These results should not be interpreted as proof that one channel is more profitable than another because the dataset does not contain channel acquisition costs.

## Monthly trend

Channel performance also changed over time.

For example, December 2024 showed strong month-over-month increases across several channels:

- Facebook Ads: approximately **€33.1K**, +100%
- Instagram: approximately **€24.6K**, +149.9%
- Email Campaign: approximately **€19.7K**, +100.5%

Because several channels increased at the same time, the data suggests a broad December uplift rather than evidence that a single campaign caused the increase.

## Limitations

This is an attribution model, not a causal model.

The dataset does not contain a direct relationship between individual sales and web sessions.

Additional limitations:

- `visit_date` is available only at day-level precision, so same-day session ordering cannot be determined reliably.
- A website checkout event does not prove that a specific sale was completed from that session.
- Offline/store purchases can be preceded by online sessions, but the available data cannot establish causality.
- Approximately 30.7% of revenue remains unattributed.
- Marketing cost data is unavailable, so true ROI and customer acquisition cost cannot be calculated.

## Business interpretation

Google is the largest attributable revenue source in the current model, while email campaigns show the highest attributed revenue per customer among channels with meaningful order volume.

However, the most important next step is not to immediately reallocate marketing budget. Before making that decision, UrbanStyle would need campaign-spend and conversion-cost data to determine whether these channels are actually profitable.

## What I learned

The main analytical challenge in this task was not the aggregation itself but identifying that the original join changed the grain of the data and inflated the result.

I learned to treat reconciliation against a trusted source total as a required validation step when building attribution or multi-table analyses.

The exercise also reinforced the difference between:

- observed association,
- attribution based on an explicit rule,
- and causal marketing effectiveness.

## Tools

- PostgreSQL / Supabase
- SQL
- CTEs
- Window functions
- `ROW_NUMBER()`
- `LAG()`
- `DATE_TRUNC()`

## AI use

AI was used extensively to help reason through the attribution problem after the original course query was found to create a fan-out join.

I used AI to explore alternative attribution approaches and SQL structure, while validating the final logic against the source sales totals and reviewing the assumptions and limitations of the model.