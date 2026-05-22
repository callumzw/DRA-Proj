/*
PROJECT: Partner Performance & Retention Analysis
AUTHOR: Callum Grant
OBJECTIVE: Generate executive-level KPIs (Total Revenue, Total Orders, New Customers, Avg Delievry Time) to track overall platform health.
*/
WITH customer_onboarding AS (
    --Identify First Order Date for New Customer Acquisition
    SELECT 
        customer_id,
        MIN(order_datetime) AS first_order_date
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY customer_id
)
SELECT 
    'Platform Performance' AS metric_scope,
    
    -- TOTAL REVENUE
    ROUND(SUM(CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.order_value END), 2) AS q3_revenue,
    ROUND(SUM(CASE WHEN o.order_datetime BETWEEN '2024-10-01' AND '2024-12-31' THEN o.order_value END), 2) AS q4_revenue,
    -- ORDER VOLUME
    COUNT(DISTINCT CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.order_id END) AS q3_orders,
    COUNT(DISTINCT CASE WHEN o.order_datetime BETWEEN '2024-10-01' AND '2024-12-31' THEN o.order_id END) AS q4_orders,
    -- NEW CUSTOMER ACQUISITION
    COUNT(DISTINCT CASE WHEN co.first_order_date BETWEEN '2024-07-01' AND '2024-09-30' THEN co.customer_id END) AS q3_new_customers,
    COUNT(DISTINCT CASE WHEN co.first_order_date BETWEEN '2024-10-01' AND '2024-12-31' THEN co.customer_id END) AS q4_new_customers,
    -- 4. AVG DELIVERY TIME
    ROUND(AVG(CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.delivery_time_minutes END), 0) AS q3_avg_delivery_mins,
    ROUND(AVG(CASE WHEN o.order_datetime BETWEEN '2024-10-01' AND '2024-12-31' THEN o.delivery_time_minutes END), 0) AS q4_avg_delivery_mins,

    -- GROWTH % CALCULATIONS
    -- Revenue Growth
    ROUND(
        (SUM(CASE WHEN o.order_datetime BETWEEN '2024-10-01' AND '2024-12-31' THEN o.order_value END) - 
         SUM(CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.order_value END)) * 100.0 /
        NULLIF(SUM(CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.order_value END), 0), 
    1) AS revenue_growth_pct,

    -- Order Growth
    ROUND(
        (COUNT(DISTINCT CASE WHEN o.order_datetime BETWEEN '2024-10-01' AND '2024-12-31' THEN o.order_id END) - 
         COUNT(DISTINCT CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.order_id END)) * 100.0 /
        NULLIF(COUNT(DISTINCT CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.order_id END), 0), 
    1) AS order_growth_pct,

    -- New Customer Growth
    ROUND(
        (COUNT(DISTINCT CASE WHEN co.first_order_date BETWEEN '2024-10-01' AND '2024-12-31' THEN co.customer_id END) - 
         COUNT(DISTINCT CASE WHEN co.first_order_date BETWEEN '2024-07-01' AND '2024-09-30' THEN co.customer_id END)) * 100.0 /
        NULLIF(COUNT(DISTINCT CASE WHEN co.first_order_date BETWEEN '2024-07-01' AND '2024-09-30' THEN co.customer_id END), 0), 
    1) AS new_customer_growth_pct,

    -- Delivery Time Change (Raw Minutes)
    ROUND(
        AVG(CASE WHEN o.order_datetime BETWEEN '2024-10-01' AND '2024-12-31' THEN o.delivery_time_minutes END) - 
        AVG(CASE WHEN o.order_datetime BETWEEN '2024-07-01' AND '2024-09-30' THEN o.delivery_time_minutes END), 
    0) AS delivery_time_change_mins

FROM orders o
LEFT JOIN customer_onboarding co ON o.customer_id = co.customer_id
WHERE o.order_status = 'completed'
  AND o.order_datetime >= '2024-07-01' 
  AND o.order_datetime < '2025-01-01';