use Delivery

select top(1000) * from orders


select top(1000) * from final_order


select avg(final_delivery_time) from final_order where distance_km>5

select max(final_delivery_time) from final_order where distance_km>5



select top 1000 final_delivery_time,delay_minutes_new from final_order 
where distance_km>5
order by final_delivery_time desc

select avg(final_delivery_time),AVG(expected_time_new),avg(delay_minutes_new) from final_order where distance_km>5


select (select count(*) from final_order where distance_km>=5)*100/count(*) from final_order

select avg(final_delivery_time),AVG(expected_time_new),avg(delay_minutes_new) from final_order where distance_km>=5

select avg(final_delivery_time),AVG(expected_time_new),avg(delay_minutes_new) from final_order where distance_km between 4 and 5

select avg(final_delivery_time),AVG(expected_time_new),avg(delay_minutes_new) from final_order where distance_km between 3 and 4

select avg(final_delivery_time),AVG(expected_time_new),avg(delay_minutes_new) from final_order where distance_km between 2 and 3

select avg(final_delivery_time),AVG(expected_time_new),avg(delay_minutes_new) from final_order where distance_km between 1 and 2

select avg(final_delivery_time) as avg_delivery,AVG(expected_time_new)as avg_expected,avg(delay_minutes_new) as avg_delay from final_order where distance_km between 0 and 1




select order_hour,count(*) as delayed_orders from final_order where distance_km>5 and delay_flag_5min=1 group by order_hour
order by 1 desc


select * from dark_stores

select * from riders

select * from final_order where customer_area=rider_area or customer_area=store_area or store_area=customer_area



select customer_area,avg(delay_minutes_new) as delay_new,avg(delay_minutes) as delay_old,count(*) as total ,avg(final_delivery_time) as del_time 
from final_order where distance_km>=5 group by customer_area


select customer_area,avg(delay_minutes_new) as delay_new,avg(delay_minutes) as delay_old,count(*) as total ,avg(final_delivery_time) as del_time 
from final_order where distance_km>=5 group by customer_area

select count(*) from final_order where delay_flag_5min=1
select count(*) from final_order where delay_flag_5min=1 and distance_km>=5

select count(*) from final_order where distance_km>=5

select count(*) from final_order where delay_flag_new_5min=1
select count(*) from final_order where delay_flag_new_5min=1 and distance_km>=5


select count(*) from final_order where delay_flag_5min=1 and order_hour between 18 and 21

select count(*) from final_order where final_delivery_time>=20 and distance_km>5

select AVG(expected_delivery_time_minutes),avg(final_delivery_time) from final_order where distance_km>5

select count(*) from final_order where  delay_flag_new_5min=1 and customer_feedback=''

refund_requested=1 and



select distinct customer_feedback,count(*) from final_order group by customer_feedback order by 2 desc

select count(*) from final_order where customer_feedback in ()

refund_requested=1 and





with cte as (
select 
case 
	when distance_km>5 then '>5'
	when distance_km between 2 and 4 then '2-4'
	when distance_km between 0 and 2 then '0-2'
	when distance_km between 4 and 5 then '4-5'
end as dist_buckets from final_order
)
select dist_buckets , 
count(*) as total  from cte group by dist_buckets
















