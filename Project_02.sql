--- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select count(distinct id) as total_user,
count(order_id) as total_order,
FORMAT_DATE('%Y-%m', delivered_at) as month_year
 from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete' and (delivered_at between '2019-01-01' and '2022-04-30')
group by FORMAT_DATE('%Y-%m', delivered_at)
order by 3  --- ko order by được theo thứ tự tháng

  ---2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
with cte_2 as (
select 
FORMAT_DATE('%Y-%m', delivered_at) as month_year,
count(distinct user_id) as distinct_users,
sum( sale_price) as sum_sale_price,
count(order_id) as count_order_id
from bigquery-public-data.thelook_ecommerce.order_items
where delivered_at between '2019-01-01' and '2022-04-30'
group by FORMAT_DATE('%Y-%m', delivered_at)
order by 1
)
select month_year, distinct_users,
round(sum_sale_price/ count_order_id,2) as average_order_value
from cte_2


--- 4.Top 5 sản phẩm mỗi tháng.
with cte_4_1 as (
select
  FORMAT_DATE('%Y-%m', created_at) as month_year,
  order_items.product_id as product_id,
  products.name as product_name,
  sum(order_items.sale_price) as sales,
  sum(products.cost) as cost, 
  sum(order_items.sale_price) - sum(products.cost) as profit
from bigquery-public-data.thelook_ecommerce.order_items as order_items
join bigquery-public-data.thelook_ecommerce.products as products 
on order_items.product_id = products.id
group by FORMAT_DATE('%Y-%m', created_at), products.name, order_items.product_id
order by 1
),
  --- Tạo cte để rank
cte_4_2 as (
select *,
dense_rank() over (partition by month_year order by profit) as rank_per_month
 from cte_4_1
)
select * from cte_4_2 
where rank_per_month <=5
