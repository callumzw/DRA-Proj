-- Insert 1000 customers with realistic signup dates across 2024
INSERT INTO customers (customer_id, signup_date)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 1000
)
SELECT 
    n AS customer_id,
    -- Create realistic signup curve: more in Jan (post-holiday) and growing through year
    DATE_ADD('2024-01-01', INTERVAL 
        CASE 
            WHEN n <= 200 THEN FLOOR(RAND() * 90)  -- Jan-Mar: 200 customers
            WHEN n <= 700 THEN 90 + FLOOR(RAND() * 183)  -- Apr-Sept: 500 customers  
            ELSE 273 + FLOOR(RAND() * 92)  -- Oct-Dec: 300 customers
        END 
    DAY) AS signup_date
FROM numbers;