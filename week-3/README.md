# Week 3 — SQL JOINs

## Role
Products + Inventory analysis

## Objective
Analyse product sales and inventory using SQL JOINs to identify:
- products that have never been sold;
- best-selling products and categories;
- inventory records requiring replenishment;
- possible inventory data-quality issues.

## Key Findings

- 12 products have never been sold.
- The same 12 products are also absent from the inventory table, so there is no evidence that they are currently tying up stock.
- Footwear (`jalanõusid`) generated the highest revenue: **€774,034.75**.
- Menswear (`meeste_riided`) generated **€749,798.72**.
- Womenswear (`naiste_riided`) generated **€686,464.24**.
- 231 inventory records are at or below their reorder point.
- 10 inventory records have negative available quantities, with the lowest reaching **-46 units**.

## Interpretation

The 12 never-sold products should not automatically be discontinued because they are not present in inventory and may never have been stocked. Their catalogue status needs to be clarified first.

The negative inventory balances should also be investigated before replenishment decisions are made, as they may indicate an inventory-control or data-quality issue.

## Recommendation

Validate the negative inventory records first. Then prioritise replenishment of proven high-selling products that are genuinely below their reorder thresholds. Separately investigate whether the 12 never-sold products are active catalogue items, inactive products, or products that were never stocked.

## Evidence

SQL analysis:
[`individual/week3_products_inventory_joins.sql`](individual/week3_products_inventory_joins.sql)

Results screenshot:
[`individual/week3_results_screenshot.png`](individual/week3_results_screenshot.png)