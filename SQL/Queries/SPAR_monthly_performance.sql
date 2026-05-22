/*
PROJECT: Partner Performance & Retention Analysis
AUTHOR: Callum Grant
OBJECTIVE: Produce granular monthly sales and operational metrics for Brand Partner (SPAR) to support periodic business reviews.
*/
SELECT
    DATE_FORMAT(o.order_datetime, '%Y-%m') AS report_month,
    r.region,
    r.retailer_name AS brand_partner,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.order_value), 2) AS total_sales_gbp,
    ROUND(AVG(o.order_value), 2) AS avg_order_value_gbp,
    ROUND(AVG(o.delivery_time_minutes), 0) AS avg_delivery_speed_mins
FROM orders o
INNER JOIN retailers r ON o.retailer_id = r.retailer_id
WHERE o.order_status = 'completed'
    AND r.retailer_name LIKE '%Spar%'
    AND o.order_datetime >= '2024-10-01'
GROUP BY report_month, r.region, r.retailer_name
ORDER BY report_month DESC, total_sales_gbp DESC;