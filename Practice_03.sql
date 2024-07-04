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

--- ex4: avg-review-ratings
SELECT EXTRACT('month' FROM submit_date) AS mth,
product_id,
ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id

--- ex5: teams-power-users.
SELECT sender_id, COUNT(message_id) AS message_count FROM messages
WHERE EXTRACT(month FROM sent_date) = 8 AND EXTRACT(year FROM sent_date) = 2022
GROUP BY sender_id 
ORDER BY message_count DESC 
LIMIT 2

--- ex6: invalid-tweets.
select tweet_id from Tweets
where length(content) > 15

--- ex7: user-activity-for-the-past-30-days
select activity_date as day,
count(distinct user_id) as active_users from Activity 
where activity_date between '2019-06-28' AND '2019-07-27'
group by activity_date

--- ex8: number-of-hires-during-specific-time-period
select count(id) as n_of_hired,
extract(month from joining_date) as mnth
from employees
where extract(year from joining_date) = 2022 
and extract(month from joining_date) between 01 and 07
group by extract(month from joining_date)

--- ex9: positions-of-letter-a
select position('a' in first_name) from worker
where first_name = 'Amitah'

--- ex10: macedonian-vintages
select substring(title, length(winery) +2, 4)
from winemag_p2
where country = 'Macedonia'
