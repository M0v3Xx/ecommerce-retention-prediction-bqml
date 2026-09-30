SELECT
  user_id,
  predicted_is_repeat,
  predicted_is_repeat_probs 
FROM ML.PREDICT(
  MODEL `e-commerce-analysis-510214.ml_project.predict_repeat_buyer`, 
  (
    WITH session_data AS(
  SELECT
    user_id,
    COUNT(DISTINCT session_id) AS total_sessions
  FROM `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY user_id),

order_data AS (
  SELECT
    user_id,
    CASE WHEN COUNT(order_id) > 1 THEN 1 ELSE 0 END AS is_repeat
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY user_id)

SELECT
  u.id AS user_id,
  u.country,
  u.gender,
  u.age,
  u.traffic_source,
  s.total_sessions,
  o.is_repeat
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
INNER JOIN order_data AS o
  ON u.id = o.user_id
LEFT JOIN session_data AS s 
  ON u.id = s.user_id)
)
