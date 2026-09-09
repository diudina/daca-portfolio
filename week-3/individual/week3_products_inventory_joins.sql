select * from inventory order by quantity_available limit 1500
-- which products have never sold? Which are the most popular? Build inventory recommendations for Anna and Toomas.

SELECT  p.product_id,  p.product_name,    p.category,    p.subcategory,    p.retail_price,    s.sale_id
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

SELECT COUNT(*) AS unsold_products
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

SELECT    p.product_name,    p.category,    p.subcategory,    COUNT(s.sale_id) AS times_sold,    SUM(s.total_price) AS total_revenue
FROM products p
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.subcategory
ORDER BY total_revenue DESC
LIMIT 10;

SELECT    p.category,    COUNT(DISTINCT p.product_id) AS products,    COUNT(s.sale_id) AS sales_count,    SUM(s.total_price) AS total_revenue
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT    p.product_name,    p.category,    i.location,    i.quantity_available,    i.reorder_point,    
  CASE        
    WHEN i.quantity_available <= i.reorder_point THEN 'REORDER'        
    ELSE 'OK'    
  END AS status
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
where i.quantity_available < 0
ORDER BY i.quantity_available ASC;

SELECT
    p.product_name,
    p.category,
    p.retail_price,
    i.location,
    i.quantity_available,
    i.reorder_point
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
ORDER BY i.quantity_available DESC;


SELECT
    p.product_name,
    p.category,
    p.retail_price,
    i.location,
    i.quantity_available,
    p.retail_price * i.quantity_available AS tied_up_value
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
  AND i.quantity_available > 0
ORDER BY tied_up_value DESC;

SELECT COUNT(*) AS products_without_inventory
FROM products p
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE i.product_id IS NULL;