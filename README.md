Partner Performance & Growth Analysis (Q4 2024)
Role Focus: Data Reporting Analyst (Quick Commerce / Retail)
Tools: SQL (MySQL), Power BI, Excel
Domain: Brand Partner Management (Premier, Spar, etc.)
Portfolio project using simulated/anonymised data

1. Project Context
This project simulates the type of reporting infrastructure required in a Data Reporting Analyst role within the quick-commerce sector. The objective was to move beyond basic transaction logging and provide actionable commercial insights for Brand Partners.
The analysis aims to answer three critical questions for retailers on the platform:
1.	Retention: Does delivery speed impact long-term customer retention?
1.	Growth Quality: Is quarterly revenue driven by more orders (volume) or by bigger baskets (value)?
3.	Partner Value: Which regions and retailers deliver the strongest contribution to platform revenue?


2. Key Insights & Commercial Recommendations
Based on the analysis of the Q4 2024 dataset:
•	Speed in 1st Time Order is a Poor Loyalty Lever: The data reveals a counterintuitive relationship: customers with 'Slow' delivery (>60 min) showed a slightly higher retention rate (54.4%) than those with 'Fast' delivery (50.9%).
o	Recommendation: Investigation into whether slower deliveries correlate with larger, planned 'weekly shop' orders where timeliness is less critical than completeness, suggesting a potential segment for differentiated service levels. In addition, invesitgate if Average  Delivery Time affects retention, oppsoed to just 1st Time Orders.
•	Scotland Leads in Value (SPAR): Regional analysis shows Scotland has the highest Average Basket Value at £36.50, significantly outperforming the South (£31.54).
o	Recommendation: Use Scottish basket composition data as a benchmark for training partners in other regions to upsell.
•	Revenue Growth Is Consistently Volume‑Driven: Revenue fluctuations correlate strongly with order count changes, while AOV remains relatively stable month‑to‑month
o	Recommendation: Focus commercial strategy on order‑stimulating levers: promotions, activation campaigns, and reactivation communications.
•	Repeat Ordering Is Low Across All Premier Regions: Orders per customer = 1.00 to 1.06 across regions.
o	Recommendation: Introduce repeat‑order incentives 


3. Technical Approach & SQL Techniques
The SQL scripts in this repository demonstrate a focus on performance, readability, and scalability.
•	Optimization: Replaced expensive subqueries in JOIN conditions with CTE-based pre-aggregation to improve query performance on large datasets.
•	Advanced Analytics: Used Window Functions (LAG(), OVER()) to calculate month-over-month growth attribution (Volume vs. Value).
•	Business Logic: Implemented complex CASE statements to categorize "Growth Drivers" and "Delivery Speeds" dynamically.
•	Standardization: All scripts use Common Table Expressions (CTEs) for modularity, making the code easier to debug and hand off to other analysts.


4. Repository Structure
Core Analysis
•	partner_report_premier_q4.sql: Regional basket analysis specifically designed for Premier retailers. Calculates AOV and frequency metrics.
•	delivery_retention.sql: Cohort analysis linking first-order delivery speed to 30-day retention rates.
•	growth_drivers.sql: A logic engine that attributes revenue growth to either "Volume" (more orders) or "Value" (higher AOV).
•	monthly_performance.sql: The standard reporting view for Brand Partners (e.g., SPAR), suitable for automated monthly exports.
Reporting Outputs
•	Partner_Dashboard_Mockup.pdf: A scalable Power BI concept designed for the "Brand Partner Portal," allowing retailers to self-serve their performance data.
