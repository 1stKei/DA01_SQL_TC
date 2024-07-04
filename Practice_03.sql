--- ex1: hackerrank-more-than-75-marks
select name from students
where marks > 75
order by right(name,3), id

--- ex2: leetcode-fix-names-in-a-table
select user_id, concat(upper(left(name,1)), lower(substring(name, 2))) as name
from Users
order by user_id

--- ex3: datalemur-total-drugs-sales
SELECT manufacturer,
'$' || round(SUM(total_sales)/1000000,0) ||' ' || 'million' AS sale 
FROM pharmacy_sales
GROUP BY(manufacturer)
ORDER BY SUM(total_sales) DESC, manufacturer
