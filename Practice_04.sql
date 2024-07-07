--- ex1: datalemur-laptop-mobile-viewership
SELECT 
  SUM(CASE
    WHEN device_type = 'laptop' THEN 1 ELSE 0
  END) AS laptop_views,
  SUM(CASE
    WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0
  END) AS mobile_views
FROM viewership;

--- ex2: datalemur-triangle-judgement
select x, y, z,
case
    when x + y > z and x + z > y and y + z > x then 'Yes'
    else 'No'
end as triangle
from Triangle

--- ex3: datalemur-uncategorized-calls-percentage
SELECT 
   round(1.0*SUM(CASE --- cast thành float
    WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0
  END) /COUNT(*)* 100, 1)
FROM callers 

---ex4: datalemur-find-customer-referee
select name from Customer
where referee_id != 2 or referee_id is null

---ex5: stratascratch the-number-of-survivors
select survived,
sum(case 
    when pclass = 1 then 1 else 0
end) as first_class,
sum(case 
    when pclass = 2 then 1 else 0
end) as second_class,
sum(case 
    when pclass = 3 then 1 else 0
end) as third_class
from titanic
group by survived
