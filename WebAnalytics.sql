SELECT 
COUNTIF(fullVisitorId is NULL) AS null_fullVisitorId,
COUNTIF(NumberOfTransactions IS NULL) AS null_transactions,
COUNTIF(OrderedAmount IS NULL) null_orderedAmount
FROM `elegant-theorem-448215-n0.webanalytics.webanalytics`;

#Geographical Analysis
select continent,
sum(pageviews) AS total_pageviews,
sum(NumberOfTransactions) AS total_transactions
from `elegant-theorem-448215-n0.webanalytics.webanalytics`
group by continent;

#Distribution of pageviews
select isMobile,
sum(pageviews) AS toal_pageviews,
sum(NumberOfTransactions) AS total_transactions,
sum(NumberOfTransactions)/sum(pageviews) AS coversion_rate
from `elegant-theorem-448215-n0.webanalytics.webanalytics`
group by isMobile;

#Distribution of RFM Score
select
RFMScore,isMobile,medium,
COUNT(*) AS Count
from `elegant-theorem-448215-n0.webanalytics.webanalytics`
group by RFMScore,isMobile,medium
Order by RFMScore ASC;

#Browser Correlation
select 
browser,
SUM(numberOfTransactions) AS total_transactions,
SUM(orderedAmount) AS total_ordered_amount
FROM `elegant-theorem-448215-n0.webanalytics.webanalytics`
GROUP BY browser;

