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


--- ex6: datalemur-repeated-payments.
WITH cte_test AS (
SELECT merchant_id, transaction_timestamp, amount,
  lag(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id ORDER BY transaction_timestamp) AS transaction_timestamp_2,
  lag(amount) OVER(PARTITION BY merchant_id, credit_card_id ORDER BY transaction_timestamp) AS amount_2
FROM transactions
)

SELECT count(*) FROM cte_test
WHERE amount = amount_2 AND transaction_timestamp - transaction_timestamp_2 <= '00:10:00'


---ex7: datalemur-highest-grossing.
WITH cte_table AS (
SELECT category, product, 
SUM(spend) AS total_spend,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend 
WHERE EXTRACT(year from transaction_date) = 2022
GROUP BY category, product
)
SELECT category, product, total_spend FROM cte_table
WHERE ranking < 3


---ex8: datalemur-top-fans-rank.
WITH cte_new_table AS (
SELECT a.artist_name,
COUNT(c.rank) AS top10_appear_count
FROM artists AS a
JOIN songs AS b ON a.artist_id = b.artist_id
JOIN global_song_rank  AS c ON c.song_id = b.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name
),
--- tạo bảng để rank
cte_2_table AS (
SELECT artist_name, 
dense_RANK() OVER(ORDER BY top10_appear_count DESC) AS artist_rank
FROM cte_new_table
)
SELECT * FROM cte_2_table
WHERE artist_rank <=5



