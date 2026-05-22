/*
PROJECT: Partner Performance & Retention Analysis
AUTHOR: Callum Grant
OBJECTIVE: Attribute monthly revenue growth to either Volume (Order Count) or Value (AOV).
*/
-- Q4: Revenue Growth Drivers (H2 2024 Focus)
WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(order_datetime, '%Y-%m') AS report_month,
        COUNT(DISTINCT order_id) AS order_volume,
        SUM(order_value) AS total_revenue_gbp,
        AVG(order_value) AS avg_order_value_gbp
    FROM orders
    WHERE order_status = 'completed'
      -- 1. FETCH FROM JUNE: Powers the July calculation (Offset)
      AND order_datetime >= '2024-06-01' 
    GROUP BY DATE_FORMAT(order_datetime, '%Y-%m')
),
growth_calculations AS (
    SELECT
        report_month,
        order_volume,
        total_revenue_gbp,
        avg_order_value_gbp,
        
        -- Volume Growth %
        (order_volume - LAG(order_volume) OVER (ORDER BY report_month)) 
          * 100.0 / NULLIF(LAG(order_volume) OVER (ORDER BY report_month), 0) AS vol_growth_pct,
          
        -- Value (AOV) Growth %
        (avg_order_value_gbp - LAG(avg_order_value_gbp) OVER (ORDER BY report_month)) 
          * 100.0 / NULLIF(LAG(avg_order_value_gbp) OVER (ORDER BY report_month), 0) AS val_growth_pct,

        -- Revenue Growth %
        (total_revenue_gbp - LAG(total_revenue_gbp) OVER (ORDER BY report_month)) 
          * 100.0 / NULLIF(LAG(total_revenue_gbp) OVER (ORDER BY report_month), 0) AS rev_growth_pct
    FROM monthly_metrics
)
SELECT
    report_month,
    order_volume,
    ROUND(total_revenue_gbp, 2) AS total_revenue_gbp,
    ROUND(avg_order_value_gbp, 2) AS avg_order_value_gbp,
    
    ROUND(rev_growth_pct, 1) AS revenue_growth_pct,
    ROUND(vol_growth_pct, 1) AS order_volume_growth_pct,
    ROUND(val_growth_pct, 1) AS avg_order_value_growth_pct,

    CASE 
        WHEN vol_growth_pct IS NULL THEN 'Baseline'
        -- Checks if the "Strength" of the swing is similar (within 1%)
        WHEN ABS(ABS(vol_growth_pct) - ABS(val_growth_pct)) <= 1.0 THEN 'Balanced Growth'
        -- Checks which metric had the bigger swing, regardless of direction
        WHEN ABS(vol_growth_pct) > ABS(val_growth_pct) THEN 'Volume Driven'
        ELSE 'Value Driven'
    END AS primary_growth_driver
FROM growth_calculations
-- 2. DISPLAY H2 ONLY: Filter by 'YYYY-MM' to match the column format
WHERE report_month >= '2024-07'
ORDER BY report_month DESC;
