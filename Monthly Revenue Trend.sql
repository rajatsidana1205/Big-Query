
#MONTHLY REVENUE TREND
SELECT 
date_trunc(date(order_date),Month) AS month,
SUM(order_amount) as Revenue,
COUNT(*) AS orders,
COUNT(DISTINCT customer_id) AS unique_customers
from `elegant-theorem-448215-n0.timeseries.timseries`
group by month
order by month;


#MONTHLY REVENUE TREND BY CHANNEL
SELECT
  DATE_TRUNC(DATE(order_date), MONTH) AS month,
  channel,
  SUM(order_amount) AS revenue,
  COUNT(*) AS orders
FROM `elegant-theorem-448215-n0.timeseries.timseries`
GROUP BY month, channel
ORDER BY month, revenue DESC;
