---ex1: hackerrank-average-population-of-each-continent.
select COUNTRY.Continent, floor(avg(CITY.Population))
from COUNTRY
inner join CITY
on CITY.CountryCode = COUNTRY.Code
group by COUNTRY.Continent

--- ex2: datalemur-signup-confirmation-rate.
SELECT ROUND(COUNT(texts.email_id)::DECIMAL
    /COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id  AND texts.signup_action = 'Confirmed'

--- ex3: datalemur-time-spent-snaps
SELECT age.age_bucket, 
  ROUND(100.0 * SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'send')/
    SUM(activities.time_spent),2) AS send_perc, 
  ROUND(100.0 * SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'open')/
    SUM(activities.time_spent),2) AS open_perc
FROM activities
INNER JOIN age_breakdown AS age 
  ON activities.user_id = age.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age.age_bucket

---ex4: datalemur-supercloud-customer.
SELECT customer_contracts.customer_id
FROM customer_contracts 
LEFT JOIN products
ON customer_contracts.product_id = products.product_id
GROUP BY customer_contracts.customer_id
HAVING COUNT(DISTINCT products.product_category) = 3 
