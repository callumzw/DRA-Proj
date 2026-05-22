/*
PROJECT: Partner Performance & Retention Analysis
AUTHOR: Callum Grant
OBJECTIVE: Regional basket analysis for Premier Retailers to identify AOV opportunities.
*/

SELECT
    r.region,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(AVG(o.order_value), 2) AS avg_basket_value_gbp,
    ROUND(COUNT(DISTINCT o.order_id) / NULLIF(COUNT(DISTINCT o.customer_id), 0), 2) AS orders_per_customer
FROM orders o
INNER JOIN retailers r ON o.retailer_id = r.retailer_id
WHERE o.order_status = 'completed'
    AND r.retailer_name LIKE '%Premier%'
    AND o.order_datetime >= DATE_SUB('2024-12-31', INTERVAL 90 DAY)
GROUP BY r.region
ORDER BY avg_basket_value_gbp DESC;