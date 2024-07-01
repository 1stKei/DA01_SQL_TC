--- ex1: hackerrank-weather-observation-station-3
selecr CITY from STATION where ID%2 = 0

--- ex2: hackerrank-weather-observation-station-4
select count(city) - count(distinct city) from station

--- ex3: hackerrank-the-blunder
select ceiling (avg(salary) - avg(replace (salary, 0, ''))) from employees

--- ex4: datalemur-alibaba-compressed-mean
SELECT ROUND(SUM(item_count::DECIMAL*order_occurrences)/SUM(order_occurrences),1) AS mean FROM items_per_order

--- ex5: datalemur-matching-skills
SELECT candidate_id FROM candidates WHERE skill IN ('Python', 'Tableau', 'PostgreSQL') 
GROUP BY candidate_id HAVING COUNT(skill) = 3
ORDER BY candidate_id;

--- ex6: datalemur-verage-post-hiatus-1
SELECT user_id,
DATE(MAX(post_date)) - DATE(MIN(post_date)) FROM posts
WHERE post_date BETWEEN '01-01-2021' AND '01-01-2022'
GROUP BY user_id
HAVING COUNT(post_id) > 1

--- ex7: datalemur-cards-issued-difference
SELECT card_name, 
MAX(issued_amount) - MIN(issued_amount) AS difference FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount) - MIN(issued_amount) DESC;

--- ex8: datalemur-non-profitable-drugs
SELECT manufacturer,
COUNT(drug) AS drug_count,
abs(sum(total_sales - cogs)) as total_loss FROM pharmacy_sales  
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC

--- ex9: leetcode-not-boring-movies
select * from cinema
where ID%2 != 0 and description != 'boring'
order by rating desc

--- ex10: leetcode-number-of-unique-subject
select teacher_id,
count(distinct subject_id) as cnt from Teacher
group by teacher_id

--- ex11: leetcode-find-followers-count
select user_id,
count(follower_id) as followers_count from Followers
group by user_id
order by user_id 

--- ex12:leetcode-classes-more-than-5-students.
select class from Courses 
group by class
having count(student) >= 5
