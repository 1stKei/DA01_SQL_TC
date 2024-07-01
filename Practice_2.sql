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
