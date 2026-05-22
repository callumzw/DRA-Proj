/*
PROJECT: Partner Performance & Retention Analysis
AUTHOR: Callum Grant
OBJECTIVE: Analyze if delivery speed on the first order impacts 30-day customer retention.
*/
WITH first_orders AS (
    SELECT 
        customer_id,
        MIN(order_datetime) AS first_order_date,
        MIN(order_id) AS first_order_id
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY customer_id
),
first_order_details AS (
    SELECT 
        fo.customer_id,
        fo.first_order_date,
        fo.first_order_id,
        o.delivery_time_minutes AS first_delivery_mins
    FROM first_orders fo
    INNER JOIN orders o ON fo.first_order_id = o.order_id
    WHERE fo.first_order_date >= '2024-03-01'
)
SELECT
    CASE 
        WHEN fod.first_delivery_mins <= 30 THEN 'Fast (<30 min)'
        WHEN fod.first_delivery_mins <= 60 THEN 'Standard (31-60 min)'
        ELSE 'Late (>60 min)'
    END AS delivery_speed,
    COUNT(DISTINCT fod.customer_id) AS total_customers,
    COUNT(DISTINCT o.customer_id) AS retained_customers,
    ROUND(COUNT(DISTINCT o.customer_id) * 100.0 / COUNT(DISTINCT fod.customer_id), 1) AS retention_rate_pct
FROM first_order_details fod
LEFT JOIN orders o ON fod.customer_id = o.customer_id
    AND o.order_datetime BETWEEN fod.first_order_date 
        AND DATE_ADD(fod.first_order_date, INTERVAL 30 DAY)
    AND o.order_id != fod.first_order_id
GROUP BY 1 -- Group by the CASE statement position
ORDER BY retention_rate_pct DESC;