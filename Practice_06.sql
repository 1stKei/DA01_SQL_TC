---ex1: datalemur-duplicate-job-listings

  ---B1: tạo 1 bảng để tính số lượng job trùng ứng với company_id, title, description
WITH cte_job_count AS (
select 
  company_id,
  title,
  description,
  COUNT(job_id) AS job_count
FROM job_listings 
GROUP BY company_id, title, description
  )
  ---B2: trả lại kết quả số lượng job trùng
SELECT count(job_count) FROM cte_job_count
WHERE job_count >= 2


--- ex2: datalemur-highest-grossing.
  --- tạo bảng có rank
WITH cte_spend_rank AS (
  SELECT category, product,
    sum(spend) AS total_spend,
    RANK() OVER (PARTITION BY category ORDER BY sum(spend) DESC) AS spend_rank
  FROM product_spend
  WHERE EXTRACT(year FROM transaction_date) = 2022
  GROUP BY category, product
)
  --- category, product, and total spend có rank <=2
SELECT category, product, total_spend 
from cte_spend_rank
where spend_rank<= 2

--- ex3: datalemur-frequent-callers.
  --- tạo bảng để đếm số cuộc gọi của từng member > 3 cuộc
WITH cte_case_id_count AS (
SELECT policy_holder_id, 
  COUNT(case_id) as case_id_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
)
  ---đếm
select count(*) as policy_holder_count from cte_case_id_count


---ex4: datalemur-page-with-no-likes.
SELECT a.page_id FROM pages as a
FULL OUTER JOIN page_likes AS b
on a.page_id = b.page_id
WHERE b.user_id is NULL
ORDER BY a.page_id ASC


--- ex5: datalemur-user-retention.
/*B1: tìm người active trong tháng 6
select DISTINCT user_id from user_actions 
WHERE EXTRACT(month FROM event_date) = 6
B2: kiểm tra xem người đó có active trong T7 không?
*/
select month,
  COUNT(DISTINCT user_id)
from user_actions 
WHERE EXTRACT(month FROM event_date) = 7 AND user_id IN ( 
  select DISTINCT user_id from user_actions 
  WHERE EXTRACT(month FROM event_date) = 6
  )
GROUP BY month


--- ex6: leetcode-monthly-transactions.
Select DATE_FORMAT(trans_date, '%Y-%m') month,,
country, 
count(id) as trans_count,
sum (case when
    state = 'approved' then 1 else 0
end )as approved_count,
sum(amount) as trans_total_amount,
sum (case when
    state = 'approved' then amount else 0
end )as approved_total_amount
from Transactions
group by month, country


---ex7: leetcode-product-sales-analysis.
  --- xếp hạng product_id dựa trên year để tìm ra 1st year
with cte_rank as (
    select sale_id, product_id, year, quantity, price,
    RANK() OVER (PARTITION BY product_id ORDER BY year asc) AS year_product_rank
    from Sales
)
select  product_id, year as first_year, quantity, price from cte_rank
where year_product_rank = 1


--- ex8: leetcode-customers-who-bought-all-products.
select customer_id from Customer
group by customer_id
having count(distinct product_key) = (select count(product_key) from Product)


---ex9: leetcode-employees-whose-manager-left-the-company.
select employee_id  from Employees 
where salary  <= 30000 and manager_id not in (select employee_id  from Employees) 


--- ex10: leetcode-primary-department-for-each-employee: trùng bài 1
--- ex11: leetcode-movie-rating.
(SELECT name AS results
FROM MovieRating JOIN Users USING(user_id)
GROUP BY name
ORDER BY COUNT(*) DESC, name
LIMIT 1)

UNION ALL

(SELECT title AS results
FROM MovieRating JOIN Movies USING(movie_id)
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002
GROUP BY title
ORDER BY AVG(rating) DESC, title
LIMIT 1);


--- ex12: leetcode-who-has-the-most-friends.
