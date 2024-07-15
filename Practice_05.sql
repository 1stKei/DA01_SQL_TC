---ex1: hackerrank-average-population-of-each-continent.
select COUNTRY.Continent, floor(avg(CITY.Population))
from COUNTRY
inner join CITY
on CITY.CountryCode = COUNTRY.Code
group by COUNTRY.Continent

--- ex2: datalemur-signup-confirmation-rate.
