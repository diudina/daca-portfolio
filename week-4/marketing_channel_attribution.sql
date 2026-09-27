-- Week 4 — Marketing Channel Effectiveness & Attribution
-- DACA Data Analyst Career Accelerator
--
-- Purpose:
--   Analyse marketing-channel effectiveness using sales and web_logs.
--
-- Important:
--   A direct join between sales and web_logs on customer_id creates a fan-out
--   problem because one customer may have many web-log rows. This duplicates
--   sales and inflates revenue.
--
-- Source-of-truth for the cleaned sales table:
--   orders  = 10,118
--   revenue = €2,909,177.98
--
-- Attribution rule:
--   For each sale, assign the latest known web session for the same customer
--   where visit_date <= sale_date. If none exists, classify as unattributed.
--
-- Limitations:
--   * No direct sale_id -> session_id relationship exists.
--   * visit_date has day-level precision only.
--   * Attribution is not causality.
--   * Marketing spend is unavailable, so true ROI/CAC cannot be calculated.


-- ============================================================
-- 1. SOURCE-OF-TRUTH VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS sales_rows,
    COUNT(DISTINCT sale_id) AS orders,
    ROUND(SUM(total_price)::numeric, 2) AS total_revenue
FROM sales;

-- Expected:
-- sales_rows    = 10,118
-- orders        = 10,118
-- total_revenue = 2,909,177.98


-- ============================================================
-- 2. LAST-TOUCH ATTRIBUTION + CHANNEL SUMMARY
-- ============================================================

WITH normalized_web_logs AS (
    SELECT
        session_id,
        customer_id,
        visit_date,
        CASE
            WHEN source IN ('Facebook', 'FB') THEN 'facebook'
            WHEN source IN ('Facebook Ads', 'facebook_ads', 'fb_ads') THEN 'facebook_ads'
            WHEN source IN (
                'google', 'Google',
                'google organic', 'Google Organic', 'google_organic'
            ) THEN 'google'
            WHEN source = 'google_ads' THEN 'google_ads'
            WHEN source IN ('IG', 'instagram', 'Instagram') THEN 'instagram'
            WHEN source IN ('ig_ads', 'instagram_ads') THEN 'instagram_ads'
            WHEN source = 'direct' THEN 'direct'
            WHEN source = 'email_campaign' THEN 'email_campaign'
            WHEN source = 'tiktok' THEN 'tiktok'
            ELSE LOWER(TRIM(source))
        END AS normalized_source
    FROM web_logs
),

session_source_counts AS (
    SELECT
        session_id,
        normalized_source,
        COUNT(*) AS source_count
    FROM normalized_web_logs
    WHERE normalized_source IS NOT NULL
    GROUP BY session_id, normalized_source
),

ranked_session_sources AS (
    SELECT
        session_id,
        normalized_source,
        source_count,
        ROW_NUMBER() OVER (
            PARTITION BY session_id
            ORDER BY source_count DESC, normalized_source ASC
        ) AS source_rank
    FROM session_source_counts
),

dominant_session_source AS (
    SELECT session_id, normalized_source
    FROM ranked_session_sources
    WHERE source_rank = 1
),

session_level AS (
    SELECT
        n.session_id,
        MAX(n.customer_id) AS customer_id,
        MAX(n.visit_date) AS visit_date,
        d.normalized_source
    FROM normalized_web_logs n
    LEFT JOIN dominant_session_source d
        ON n.session_id = d.session_id
    GROUP BY n.session_id, d.normalized_source
),

candidate_touches AS (
    SELECT
        s.sale_id,
        s.customer_id,
        s.sale_date,
        s.total_price,
        sl.session_id,
        sl.visit_date,
        sl.normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY s.sale_id
            ORDER BY
                sl.visit_date DESC NULLS LAST,
                sl.session_id DESC NULLS LAST
        ) AS touch_rank
    FROM sales s
    LEFT JOIN session_level sl
        ON s.customer_id = sl.customer_id
       AND sl.visit_date <= s.sale_date
),

attributed_sales AS (
    SELECT
        sale_id,
        customer_id,
        sale_date,
        total_price,
        COALESCE(normalized_source, 'unattributed') AS marketing_channel
    FROM candidate_touches
    WHERE touch_rank = 1
)

SELECT
    marketing_channel,
    COUNT(DISTINCT sale_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(total_price)::numeric, 2) AS total_revenue,
    ROUND(AVG(total_price)::numeric, 2) AS average_order_value
FROM attributed_sales
GROUP BY marketing_channel
ORDER BY total_revenue DESC;

-- Final result:
-- unattributed   3054 orders   916 customers   €893,781.80   AOV €292.66
-- google         2088 orders   958 customers   €602,611.99   AOV €288.61
-- direct         1258 orders   626 customers   €346,580.04   AOV €275.50
-- facebook_ads   1175 orders   537 customers   €332,978.90   AOV €283.39
-- email_campaign  832 orders   360 customers   €242,639.78   AOV €291.63
-- instagram       819 orders   402 customers   €239,831.93   AOV €292.84
-- google_ads      499 orders   260 customers   €145,797.69   AOV €292.18
-- tiktok          351 orders   194 customers    €92,337.57   AOV €263.07
-- facebook         38 orders    16 customers    €11,905.93   AOV €313.31
-- instagram_ads     4 orders     3 customers       €712.35   AOV €178.09
--
-- Reconciliation:
-- orders  = 10,118
-- revenue = €2,909,177.98


-- ============================================================
-- 3. ATTRIBUTION COVERAGE CHECK
-- ============================================================

WITH normalized_web_logs AS (
    SELECT
        session_id,
        customer_id,
        visit_date,
        CASE
            WHEN source IN ('Facebook', 'FB') THEN 'facebook'
            WHEN source IN ('Facebook Ads', 'facebook_ads', 'fb_ads') THEN 'facebook_ads'
            WHEN source IN (
                'google', 'Google',
                'google organic', 'Google Organic', 'google_organic'
            ) THEN 'google'
            WHEN source = 'google_ads' THEN 'google_ads'
            WHEN source IN ('IG', 'instagram', 'Instagram') THEN 'instagram'
            WHEN source IN ('ig_ads', 'instagram_ads') THEN 'instagram_ads'
            WHEN source = 'direct' THEN 'direct'
            WHEN source = 'email_campaign' THEN 'email_campaign'
            WHEN source = 'tiktok' THEN 'tiktok'
            ELSE LOWER(TRIM(source))
        END AS normalized_source
    FROM web_logs
),
session_source_counts AS (
    SELECT session_id, normalized_source, COUNT(*) AS source_count
    FROM normalized_web_logs
    WHERE normalized_source IS NOT NULL
    GROUP BY session_id, normalized_source
),
ranked_session_sources AS (
    SELECT
        session_id,
        normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY session_id
            ORDER BY source_count DESC, normalized_source ASC
        ) AS source_rank
    FROM session_source_counts
),
dominant_session_source AS (
    SELECT session_id, normalized_source
    FROM ranked_session_sources
    WHERE source_rank = 1
),
session_level AS (
    SELECT
        n.session_id,
        MAX(n.customer_id) AS customer_id,
        MAX(n.visit_date) AS visit_date,
        d.normalized_source
    FROM normalized_web_logs n
    LEFT JOIN dominant_session_source d
        ON n.session_id = d.session_id
    GROUP BY n.session_id, d.normalized_source
),
candidate_touches AS (
    SELECT
        s.sale_id,
        s.total_price,
        sl.session_id,
        sl.visit_date,
        sl.normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY s.sale_id
            ORDER BY
                sl.visit_date DESC NULLS LAST,
                sl.session_id DESC NULLS LAST
        ) AS touch_rank
    FROM sales s
    LEFT JOIN session_level sl
        ON s.customer_id = sl.customer_id
       AND sl.visit_date <= s.sale_date
),
attributed_sales AS (
    SELECT
        sale_id,
        total_price,
        COALESCE(normalized_source, 'unattributed') AS marketing_channel
    FROM candidate_touches
    WHERE touch_rank = 1
)
SELECT
    CASE
        WHEN marketing_channel = 'unattributed' THEN 'unattributed'
        ELSE 'attributed'
    END AS attribution_status,
    COUNT(*) AS orders,
    ROUND(SUM(total_price)::numeric, 2) AS revenue,
    ROUND(
        100.0 * SUM(total_price) / SUM(SUM(total_price)) OVER (),
        1
    ) AS revenue_share_pct
FROM attributed_sales
GROUP BY
    CASE
        WHEN marketing_channel = 'unattributed' THEN 'unattributed'
        ELSE 'attributed'
    END
ORDER BY revenue DESC;

-- Final result:
-- attributed   = €2,015,396.18 = 69.3%
-- unattributed =   €893,781.80 = 30.7%


-- ============================================================
-- 4. CHANNEL EFFECTIVENESS
--    Revenue per customer for channels with >100 orders
-- ============================================================

WITH normalized_web_logs AS (
    SELECT
        session_id,
        customer_id,
        visit_date,
        CASE
            WHEN source IN ('Facebook', 'FB') THEN 'facebook'
            WHEN source IN ('Facebook Ads', 'facebook_ads', 'fb_ads') THEN 'facebook_ads'
            WHEN source IN (
                'google', 'Google',
                'google organic', 'Google Organic', 'google_organic'
            ) THEN 'google'
            WHEN source = 'google_ads' THEN 'google_ads'
            WHEN source IN ('IG', 'instagram', 'Instagram') THEN 'instagram'
            WHEN source IN ('ig_ads', 'instagram_ads') THEN 'instagram_ads'
            WHEN source = 'direct' THEN 'direct'
            WHEN source = 'email_campaign' THEN 'email_campaign'
            WHEN source = 'tiktok' THEN 'tiktok'
            ELSE LOWER(TRIM(source))
        END AS normalized_source
    FROM web_logs
),
session_source_counts AS (
    SELECT session_id, normalized_source, COUNT(*) AS source_count
    FROM normalized_web_logs
    WHERE normalized_source IS NOT NULL
    GROUP BY session_id, normalized_source
),
ranked_session_sources AS (
    SELECT
        session_id,
        normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY session_id
            ORDER BY source_count DESC, normalized_source ASC
        ) AS source_rank
    FROM session_source_counts
),
dominant_session_source AS (
    SELECT session_id, normalized_source
    FROM ranked_session_sources
    WHERE source_rank = 1
),
session_level AS (
    SELECT
        n.session_id,
        MAX(n.customer_id) AS customer_id,
        MAX(n.visit_date) AS visit_date,
        d.normalized_source
    FROM normalized_web_logs n
    LEFT JOIN dominant_session_source d
        ON n.session_id = d.session_id
    GROUP BY n.session_id, d.normalized_source
),
candidate_touches AS (
    SELECT
        s.sale_id,
        s.customer_id,
        s.total_price,
        sl.session_id,
        sl.visit_date,
        sl.normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY s.sale_id
            ORDER BY
                sl.visit_date DESC NULLS LAST,
                sl.session_id DESC NULLS LAST
        ) AS touch_rank
    FROM sales s
    LEFT JOIN session_level sl
        ON s.customer_id = sl.customer_id
       AND sl.visit_date <= s.sale_date
),
attributed_sales AS (
    SELECT
        sale_id,
        customer_id,
        total_price,
        COALESCE(normalized_source, 'unattributed') AS marketing_channel
    FROM candidate_touches
    WHERE touch_rank = 1
)
SELECT
    marketing_channel,
    COUNT(DISTINCT sale_id) AS orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(total_price)::numeric, 2) AS total_sales,
    ROUND(
        (SUM(total_price) / NULLIF(COUNT(DISTINCT customer_id), 0))::numeric,
        2
    ) AS sales_per_customer
FROM attributed_sales
GROUP BY marketing_channel
HAVING COUNT(DISTINCT sale_id) > 100
ORDER BY sales_per_customer DESC;

-- Final result:
-- unattributed    3054 orders  916 customers  €893,781.80  €975.74/customer
-- email_campaign   832 orders  360 customers  €242,639.78  €674.00/customer
-- google          2088 orders  958 customers  €602,611.99  €629.03/customer
-- facebook_ads    1175 orders  537 customers  €332,978.90  €620.07/customer
-- instagram        819 orders  402 customers  €239,831.93  €596.60/customer
-- google_ads       499 orders  260 customers  €145,797.69  €560.76/customer
-- direct          1258 orders  626 customers  €346,580.04  €553.64/customer
-- tiktok           351 orders  194 customers   €92,337.57  €475.97/customer
--
-- 'unattributed' is shown for completeness but is not a marketing channel.


-- ============================================================
-- 5. MONTHLY CHANNEL TREND + MONTH-OVER-MONTH CHANGE
-- ============================================================

WITH normalized_web_logs AS (
    SELECT
        session_id,
        customer_id,
        visit_date,
        CASE
            WHEN source IN ('Facebook', 'FB') THEN 'facebook'
            WHEN source IN ('Facebook Ads', 'facebook_ads', 'fb_ads') THEN 'facebook_ads'
            WHEN source IN (
                'google', 'Google',
                'google organic', 'Google Organic', 'google_organic'
            ) THEN 'google'
            WHEN source = 'google_ads' THEN 'google_ads'
            WHEN source IN ('IG', 'instagram', 'Instagram') THEN 'instagram'
            WHEN source IN ('ig_ads', 'instagram_ads') THEN 'instagram_ads'
            WHEN source = 'direct' THEN 'direct'
            WHEN source = 'email_campaign' THEN 'email_campaign'
            WHEN source = 'tiktok' THEN 'tiktok'
            ELSE LOWER(TRIM(source))
        END AS normalized_source
    FROM web_logs
),
session_source_counts AS (
    SELECT session_id, normalized_source, COUNT(*) AS source_count
    FROM normalized_web_logs
    WHERE normalized_source IS NOT NULL
    GROUP BY session_id, normalized_source
),
ranked_session_sources AS (
    SELECT
        session_id,
        normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY session_id
            ORDER BY source_count DESC, normalized_source ASC
        ) AS source_rank
    FROM session_source_counts
),
dominant_session_source AS (
    SELECT session_id, normalized_source
    FROM ranked_session_sources
    WHERE source_rank = 1
),
session_level AS (
    SELECT
        n.session_id,
        MAX(n.customer_id) AS customer_id,
        MAX(n.visit_date) AS visit_date,
        d.normalized_source
    FROM normalized_web_logs n
    LEFT JOIN dominant_session_source d
        ON n.session_id = d.session_id
    GROUP BY n.session_id, d.normalized_source
),
candidate_touches AS (
    SELECT
        s.sale_id,
        s.customer_id,
        s.sale_date,
        s.total_price,
        sl.session_id,
        sl.visit_date,
        sl.normalized_source,
        ROW_NUMBER() OVER (
            PARTITION BY s.sale_id
            ORDER BY
                sl.visit_date DESC NULLS LAST,
                sl.session_id DESC NULLS LAST
        ) AS touch_rank
    FROM sales s
    LEFT JOIN session_level sl
        ON s.customer_id = sl.customer_id
       AND sl.visit_date <= s.sale_date
),
attributed_sales AS (
    SELECT
        sale_id,
        customer_id,
        sale_date,
        total_price,
        COALESCE(normalized_source, 'unattributed') AS marketing_channel
    FROM candidate_touches
    WHERE touch_rank = 1
),
monthly_channel_summary AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        marketing_channel,
        COUNT(DISTINCT sale_id) AS orders,
        COUNT(DISTINCT customer_id) AS unique_customers,
        SUM(total_price) AS revenue
    FROM attributed_sales
    GROUP BY DATE_TRUNC('month', sale_date), marketing_channel
),
with_previous_month AS (
    SELECT
        month,
        marketing_channel,
        orders,
        unique_customers,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY marketing_channel
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_channel_summary
)
SELECT
    month,
    marketing_channel,
    orders,
    unique_customers,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(previous_month_revenue::numeric, 2) AS previous_month_revenue,
    ROUND((revenue - previous_month_revenue)::numeric, 2) AS revenue_change,
    ROUND(
        (
            100.0 * (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        )::numeric,
        1
    ) AS revenue_growth_pct
FROM with_previous_month
ORDER BY month, revenue DESC;

-- Example finding from December 2024:
-- facebook_ads   ~ €33.1K, +100.0% MoM
-- instagram      ~ €24.6K, +149.9% MoM
-- email_campaign ~ €19.7K, +100.5% MoM
--
-- Interpretation:
-- Several channels increased strongly in the same month. This supports
-- describing December as a broad uplift, but does not prove that one
-- particular campaign caused the increase.


-- ============================================================
-- 6. FINAL RECONCILIATION CHECK
-- ============================================================

-- After attribution, confirm again:
--   COUNT(DISTINCT sale_id) = 10,118
--   SUM(total_price)        = 2,909,177.98
--
-- If these totals do not match the sales source-of-truth, stop and
-- investigate before interpreting any channel-level result.
