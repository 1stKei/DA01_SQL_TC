--- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select count(distinct id) as total_user,
count(order_id) as total_order,
--- không to_char hay convert được :)
extract(year from delivered_at) || "-" || extract(month from delivered_at) as month_year
 from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete' and (delivered_at between '2019-01-01' and '2022-04-30')
group by extract(year from delivered_at) || "-" || extract(month from delivered_at)
order by 3  --- ko order by được theo thứ tự tháng

  ---2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
with cte_2 as (
select 
--- không to_char hay convert được :)
extract(year from delivered_at) || "-" || extract(month from delivered_at) as month_year,
count(distinct user_id) as distinct_users,
sum( sale_price) as sum_sale_price,
count(order_id) as count_order_id
from bigquery-public-data.thelook_ecommerce.order_items
where delivered_at between '2019-01-01' and '2022-04-30'
group by extract(year from delivered_at) || "-" || extract(month from delivered_at)
order by 1
)
select month_year, distinct_users,
round(sum_sale_price/ count_order_id,2) as average_order_value
from cte_2
