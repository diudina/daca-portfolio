# Week 3 — Team JOIN Analysis

**Team:** Customer Insights  
**Stakeholders:** Anna Mets, Toomas Kask

## Key Findings

1. **Top customers and markets**
   Tallinn is UrbanStyle's strongest customer market, generating more than **€1.0M in customer spend**. Tiina Pärn was the highest-spending customer with **€27,668.02 across 73 purchases**. Around **29.9% of active customers are above-average spenders**, providing a clear high-value segment for targeted marketing. However, **1,024 purchasing customers have no loyalty tier recorded**, limiting reliable loyalty-based segmentation.

2. **Lost customers**
   We identified **599 registered customers who have never made a purchase**, compared with **2,551 active customers**. Tallinn has the largest number of lost customers (**231**), and January consistently shows the highest number of lost-customer registrations across the analysed period. These customers represent a potential first-purchase campaign segment, but the available data does not explain why they failed to convert.

3. **Products and inventory**
   **12 products have never been sold**, and the same 12 products are also absent from the inventory table. This means there is no evidence that they are currently tying up stock, and their catalogue status needs to be clarified before any discontinuation decision is made.

   Footwear (`jalanõusid`) is the strongest-performing category by revenue at **€774,034.75**, followed by menswear (`meeste_riided`) at **€749,798.72** and womenswear (`naiste_riided`) at **€686,464.24**.

   **231 inventory records are at or below their reorder point**, while **10 inventory records have negative available quantities**. These negative balances should be validated before replenishment decisions are made.

4. **Sales channels**
   In-store (`pood`) generated approximately **€1.9M in revenue from 2,278 customers**, compared with approximately **€1.0M from 1,706 online customers**. Revenue per customer was also higher in-store (**€835 vs €590**).

   Tallinn is the strongest market across both channels. At the same time, online sales remain substantial and show potential for further testing, particularly among Tartu and Pärnu customers.

## Biggest Surprise

The team found several unexpected signals across the data: **599 registered customers have never purchased, 1,024 purchasing customers have no loyalty tier, and 10 inventory records show negative stock quantities**.

The clearest recurring behavioural pattern was that **January consistently had the highest number of lost-customer registrations** across the five-year period.

## Recommendation for Anna

Prioritise three customer segments:

- high-value active customers, particularly in Tallinn;
- registered customers who have never purchased, using a controlled first-purchase campaign;
- online customers in Tartu and Pärnu as a potential growth segment.

Before relying on loyalty-based targeting or inventory-driven decisions, UrbanStyle should first resolve missing loyalty-tier data and investigate negative inventory balances.

For products, replenishment should prioritise proven high-selling items that are genuinely below their reorder thresholds. The 12 never-sold products should be reviewed separately because they have no inventory records and may never have been stocked.

## Missing Data / Open Questions

The current data does not explain:

- why the 599 registered customers never converted;
- whether the January pattern is linked to acquisition campaigns, seasonality, or another factor;
- why 1,024 purchasing customers have no loyalty tier;
- whether the 12 never-sold products are active catalogue items, inactive items, or products that were never stocked;
- why 10 inventory records contain negative quantities;
- whether differences between online and in-store performance are related to marketing spend, campaign activity, customer behaviour, or channel costs.

Additional data on acquisition source, website behaviour, checkout drop-off, campaign exposure and cost, customer engagement, and product/catalogue status would be needed before making stronger causal conclusions.