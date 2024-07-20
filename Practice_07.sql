--- ex1: datalemur-yoy-growth-rate.
SELECT EXTRACT(year FROM transaction_date) as year, 
product_id,
spend as curr_year_spend,
lag(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) as prev_year_spend,
round((spend - lag(spend) OVER(PARTITION BY product_id ORDER BY transaction_date))
/lag(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) *100, 2)
FROM user_transactions;
