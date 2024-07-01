--- ex1: hackerrank-weather-observation-station-3
selecr CITY from STATION where ID%2 = 0

--- ex2: hackerrank-weather-observation-station-4
select count(city) - count(distinct city) from station

--- ex3: hackerrank-the-blunder
select ceiling (avg(salary) - avg(replace (salary, 0, ''))) from employees
