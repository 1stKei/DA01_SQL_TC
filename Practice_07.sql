--- ex1: datalemur-yoy-growth-rate.
SELECT EXTRACT(year FROM transaction_date) as year, 
product_id,
spend as curr_year_spend,
lag(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) as prev_year_spend,
round((spend - lag(spend) OVER(PARTITION BY product_id ORDER BY transaction_date))
/lag(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) *100, 2)
FROM user_transactions;


---ex2: datalemur-card-launch-success.
WITH cte_month_rank AS (
SELECT *, 
RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS rank_month
 FROM monthly_cards_issued
)
select card_name, issued_amount FROM cte_month_rank
WHERE rank_month = 1
ORDER BY issued_amount DESC

  
--- ex3: datalemur-third-transaction.
WITH cte_rank_transaction_date AS (
SELECT *,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rank_transact
FROM transactions
)
SELECT user_id, spend, transaction_date FROM cte_rank_transaction_date
WHERE rank_transact = 3


--- ex4: datalemur-histogram-users-purchases.
WITH cte_rank_recent_date AS (
SELECT transaction_date, user_id, product_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as rank_recent
FROM user_transactions 
)

SELECT  transaction_date, 
  user_id,
  COUNT(rank_recent) AS purchase_count
FROM cte_rank_recent_date
WHERE rank_recent = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date


--- ex5: datalemur-rolling-average-tweets.
WITH cte_111 AS (
SELECT *,
lag(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) AS lag_1,
lag(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) AS lag_2
FROM tweets
)

SELECT user_id, tweet_date,
CASE WHEN lead_1 is NULL AND lead_2 is NULL THEN tweet_count*1.00
    WHEN lead_1 is NOT NULL AND lead_2 is NULL THEN ROUND((tweet_count + lead_1)*1.0/2, 2)
    ELSE ROUND((tweet_count + lead_1 + lead_2)* 1.0/ 3, 2)
END as rolling_avg
FROM cte_111
/*=> cách khác nhanh hơn không?*/

