#  Quick Commerce Delivery Operations Analysis

A end-to-end data analytics project analyzing **80,000 orders** from a quick commerce delivery platform (similar to Blinkit/Zepto) using **SQL Server** for data analysis and **Power BI** for visualization.

---

##  Dashboard Preview

> 3-page interactive Power BI dashboard covering Operations Overview, DarkStores Analysis, and Delivery Analysis.

---

##  Dataset Overview

| Table | Rows | Description |
|-------|------|-------------|
| `orders` | 80,000 | Core order data with delivery times, distances, ratings |
| `customers` | 20,000 | Customer profiles and areas |
| `riders` | 500 | Rider details and assigned areas |
| `dark_stores` | 20 | Store locations and hourly capacity |

**Time Period:** January 2025 – March 2025  
**City:** Delhi NCR (20 areas)

---

## 🔑 Key Metrics

| Metric | Value |
|--------|-------|
| Total Orders | 80,000 |
| Total Revenue | ₹36.02M |
| Average Order Value | ₹450.29 |
| Avg. Delivery Time | 19.72 min |
| Overall Delay Rate | 81% |
| Refund Rate | 18.99% |
| Unique Customers | 19,619 |

---

## 🔍 Key Findings

### Delivery Performance
- Delay rate peaks at **98.2% between 7–9 PM** — the evening rush window
- Orders beyond **5 km (18.2% of all orders)** average **19.7** delivery time
- On-time delivery rate stands at **81.99%** using a 5-minute buffer threshold

### Dark Store Analysis
- **Best Store:** DS116 | **Worst Store:** DS119 (18.79% delay rate)
- Store capacity utilization peaks at **14.3%** per hour — suggesting room for order volume growth
- Refund rates vary from **17% to 21%** across the 20 stores

### Rider Performance
- Worst-performing riders have delay rates exceeding **88.5–91.1%**
- **Connaught Place** is the highest-delay area at **20.51%**
- **Punjabi Bagh (82.3%)** and **Dwarka (82.2%)** are the worst customer areas by delay

### Product & Payment Insights
- **Beverages** (10.1K orders) is the top category; **Baby Care** the lowest
- **UPI dominates** payments at 50% (40K orders); Cash on Delivery at just 10%
- Household & Personal Care have the highest refund rates at **21.7%**

---

## 🛠️ Tools & Technologies

- **SQL Server** — Data cleaning, transformation, CTEs, window functions, multi-table joins
- **Power BI** — Interactive dashboard with slicers (Month, Day), KPI cards, bar/scatter charts
- **Excel/CSV** — Raw dataset storage

---

## 📁 Project Structure

```
├── datasets/
│   ├── orders.csv
│   ├── customers.csv
│   ├── riders.csv
│   └── dark_stores.csv
├── sql/
│   ├── Analysis.sql          # Core delivery & delay analysis
│   └── Analysis_new.sql      # Distance segmentation & advanced queries
├── dashboard/
│   └── DeliveryDashboard.pbix
└── README.md
```

---

## 💡 SQL Highlights

```sql
-- Delay rate by hour with buffer thresholds
SELECT
    order_hour,
    100.0 * SUM(CASE WHEN delivery_time_minutes > expected_delivery_time_minutes + 5 
                THEN 1 ELSE 0 END) / COUNT(*) AS delay_pct_5min_buffer
FROM final_order
GROUP BY order_hour
ORDER BY delay_pct_5min_buffer DESC;

-- Store capacity utilization
WITH cte AS (
    SELECT dark_store_id, store_capacity_orders_per_hour,
           order_hour, COUNT(*) AS orders_in_hour
    FROM dark_stores d JOIN final_order f ON f.dark_store_id = d.dark_store_id
    GROUP BY dark_store_id, store_capacity_orders_per_hour, order_hour
)
SELECT dark_store_id,
       AVG(orders_in_hour) AS avg_orders_per_hour,
       CAST(100.0 * AVG(orders_in_hour) / store_capacity_orders_per_hour AS DECIMAL(10,2)) AS avg_utilization_pct
FROM cte
GROUP BY dark_store_id, store_capacity_orders_per_hour;
```

---

