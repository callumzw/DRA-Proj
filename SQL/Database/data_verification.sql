-- Data verification and sample queries
SELECT '=== DATA VOLUMES ===' as info;
SELECT 'retailers' as table_name, COUNT(*) as record_count FROM retailers
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;

SELECT '=== ORDER DATE RANGE ===' as info;
SELECT 
    MIN(order_datetime) as first_order,
    MAX(order_datetime) as last_order,
    DATEDIFF(MAX(order_datetime), MIN(order_datetime)) as days_covered,
    COUNT(*) as total_orders
FROM orders;

SELECT '=== RETAILER DISTRIBUTION ===' as info;
SELECT 
    CASE 
        WHEN retailer_id <= 26 THEN 'Brand Partner' 
        ELSE 'Independent' 
    END as retailer_type,
    COUNT(*) as order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 1) as percentage
FROM orders
GROUP BY retailer_type
ORDER BY order_count DESC;

SELECT '=== ORDER STATISTICS ===' as info;
SELECT 
    ROUND(AVG(order_value), 2) as avg_order_value,
    ROUND(MIN(order_value), 2) as min_order_value,
    ROUND(MAX(order_value), 2) as max_order_value,
    ROUND(AVG(delivery_time_minutes), 0) as avg_delivery_time,
    ROUND(
        SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        1
    ) as cancellation_rate_pct,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders;

SELECT '=== SAMPLE DATA PREVIEW ===' as info;
SELECT * FROM retailers WHERE retailer_id <= 5;
SELECT * FROM customers WHERE customer_id <= 5;
SELECT * FROM orders WHERE order_id <= 5;