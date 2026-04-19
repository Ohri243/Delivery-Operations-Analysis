

use delivery


SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN delivery_time_minutes > expected_delivery_time_minutes THEN 1 ELSE 0 END) AS delayed_orders,
    100.0 * SUM(CASE WHEN delivery_time_minutes > expected_delivery_time_minutes THEN 1 ELSE 0 END) / COUNT(*) AS delay_rate_pct
FROM orders;

SELECT 
    AVG(delivery_time_minutes) AS avg_delivery_time,
    AVG(expected_delivery_time_minutes) AS avg_expected_time,
    AVG(delivery_time_minutes - expected_delivery_time_minutes) AS avg_gap
FROM orders;



SELECT
    100.0 * SUM(CASE WHEN delivery_time_minutes > expected_delivery_time_minutes THEN 1 ELSE 0 END) / COUNT(*) AS strict_delay_pct,
    100.0 * SUM(CASE WHEN delivery_time_minutes > expected_delivery_time_minutes + 3 THEN 1 ELSE 0 END) / COUNT(*) AS delay_pct_3min_buffer,
    100.0 * SUM(CASE WHEN delivery_time_minutes > expected_delivery_time_minutes + 5 THEN 1 ELSE 0 END) / COUNT(*) AS delay_pct_5min_buffer
FROM orders;

select count(*) from orders


select dark_store_id, count(order_id) from orders group by dark_store_id

select * from orders where customer_id='C17399'

select count(distinct customer_id) from orders

select count(*) from customers

select customer_id from customers where not exists(select customer_id from orders)

select customer_id from customers where customer_id not in (select customer_id from orders)





SELECT * INTO orders_backup FROM orders;
SELECT * INTO customers_backup FROM customers;


SELECT customer_area, COUNT(*) AS customers
FROM customers_backup
GROUP BY customer_area
ORDER BY customers DESC;


select * from dark_stores




select top(100) * from final_order

with cte as (

select d.dark_store_id,d.store_area,d.store_capacity_orders_per_hour,f.order_hour, count(*) as working_capacity from final_order f join dark_stores d
on f.dark_store_id=d.dark_store_id group by d.dark_store_id,d.store_area,d.store_capacity_orders_per_hour,f.order_hour order by dark_store_id
,order_hour
)
select * from cte 


with cte as (
select d.dark_store_id,d.store_area,d.store_capacity_orders_per_hour,f.order_hour,count(*) as order_in__hour
from dark_stores d join final_order f
on f.dark_store_id=d.dark_store_id
group by d.dark_store_id,d.store_area,d.store_capacity_orders_per_hour,f.order_hour

)
select dark_store_id,store_area,store_capacity_orders_per_hour,AVG(order_in__hour)

from cte 
group by dark_store_id,store_area,store_capacity_orders_per_hour


select dark_store_id,store_area,AVG(count(*)) over(partition by order_hour) from final_order
group by dark_store_id,store_area,order_hour
order by dark_store_id






WITH cte AS (
    SELECT 
        d.dark_store_id,
        d.store_area,
        d.store_capacity_orders_per_hour,
        CAST(f.order_datetime AS DATE) AS order_date,
        f.order_hour,
        COUNT(*) AS orders_in_hour
    FROM dark_stores d
    JOIN final_order f
        ON f.dark_store_id = d.dark_store_id
    GROUP BY 
        d.dark_store_id,
        d.store_area,
        d.store_capacity_orders_per_hour,
        CAST(f.order_datetime AS DATE),
        f.order_hour
)

SELECT 
    dark_store_id,
    store_area,
    store_capacity_orders_per_hour,
    AVG(orders_in_hour) AS avg_orders_per_hour,
    
    CAST(
        100.0 * AVG(orders_in_hour) / store_capacity_orders_per_hour
        AS DECIMAL(10,2)
    ) AS avg_utilization_pct

FROM cte
GROUP BY 
    dark_store_id,
    store_area,
    store_capacity_orders_per_hour
ORDER BY avg_utilization_pct DESC;

----------------------------------

WITH cte AS (
    SELECT 
        d.dark_store_id,
        d.store_area,
        d.store_capacity_orders_per_hour,
        CAST(f.order_datetime AS DATE) AS order_date,
        f.order_hour,
        COUNT(*) AS orders_in_hour
    FROM dark_stores d
    JOIN final_order f
        ON f.dark_store_id = d.dark_store_id
    GROUP BY 
        d.dark_store_id,
        d.store_area,
        d.store_capacity_orders_per_hour,
        CAST(f.order_datetime AS DATE),
        f.order_hour
)

SELECT 
    dark_store_id,
    store_area,
    store_capacity_orders_per_hour,
    MAX(orders_in_hour) AS peak_orders_per_hour,
    
    CAST(
        100.0 * MAX(orders_in_hour) / store_capacity_orders_per_hour
        AS DECIMAL(10,2)
    ) AS peak_utilization_pct

FROM cte
GROUP BY 
    dark_store_id,
    store_area,
    store_capacity_orders_per_hour
ORDER BY peak_utilization_pct DESC;





