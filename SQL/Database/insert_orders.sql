-- Insert 3000 orders with realistic patterns
INSERT INTO orders (order_id, order_datetime, retailer_id, customer_id, order_value, order_status, delivery_time_minutes)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 3000
)
SELECT 
    n AS order_id,
    DATE_ADD('2024-01-01 08:00:00', INTERVAL FLOOR(RAND() * 31536000) SECOND) AS order_datetime,
    FLOOR(1 + RAND() * 50) AS retailer_id,
    FLOOR(1 + RAND() * 1000) AS customer_id,
    ROUND(10 + RAND() * 50, 2) AS order_value,
    CASE WHEN RAND() < 0.95 THEN 'completed' ELSE 'cancelled' END AS order_status,
    CASE 
        WHEN RAND() < 0.85 THEN FLOOR(15 + RAND() * 45)
        ELSE FLOOR(60 + RAND() * 120)
    END AS delivery_time_minutes
FROM numbers;