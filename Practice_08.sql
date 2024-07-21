--- ex1: leetcode-mmediate-food-delivery.

/*rank để tìm order đầu tiên sau đó chọn các order khi order_date = order_date  
và rank = 1*/
--- Rank để tìm order đầu tiên
with cte_new_table as (
select *,
rank() over (partition by customer_id  order by order_date) as stt_order
from Delivery 
),
--- đếm số order đầu được giao immediate
cte_immediate_order_count as (
select count(*)  as immediate_order_count from cte_new_table
where stt_order = 1 and order_date  = customer_pref_delivery_date
),
--- đếm số order đầu
cte_1st_order_count as (
select count(*)  as first_order_count from cte_new_table
where stt_order = 1 
)
--- tinsh %
select 
round (1.00*(select immediate_order_count from cte_immediate_order_count)
/ (select first_order_count from cte_1st_order_count) * 100, 2) as immediate_percentage
