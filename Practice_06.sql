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


