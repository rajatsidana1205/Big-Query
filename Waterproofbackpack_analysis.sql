-- ============================================================
-- Project: Waterproof Backpack – E-commerce Product Analysis
-- Tool: Google BigQuery
-- Dataset: Google Analytics Ecommerce
-- Objective:
--   Analyse traffic sources, engagement and user behaviour
--   for the product "Waterproof Backpack"
-- ============================================================

-- ============================================================
-- 1. Channel Performance
-- How many unique users viewed the product per channel?
-- ============================================================

SELECT
  channelGrouping,
  COUNT(DISTINCT fullVisitorId) 
FROM `elegant-theorem-448215-n0.ecommerce.ecommerce`
WHERE v2ProductName = 'Waterproof Backpack'
GROUP BY channelGrouping;

-- ============================================================
-- 2. Country Engagement
-- Which countries have the highest average session duration?
-- ============================================================
SELECT
  country,
  AVG(timeOnSite) AS avg_time_on_site
FROM `elegant-theorem-448215-n0.ecommerce.ecommerce`
WHERE timeOnSite IS NOT NULL
GROUP BY country
ORDER BY avg_time_on_site DESC;

-- ============================================================
-- 3. Power Users
-- Users who viewed the most pages (repeat engagement)
-- ============================================================
SELECT
  fullVisitorId,
  SUM(pageviews) AS total_pageviews
FROM `elegant-theorem-448215-n0.ecommerce.ecommerce`
GROUP BY fullVisitorId
Having count(*)>1
limit 5;

-- ============================================================
-- 4. Top Landing Pages by Channel
-- Which pages attract users in each channel?
-- ============================================================
SELECT
v2ProductName,
SUM(pageviews) AS total_pageviews
FROM `elegant-theorem-448215-n0.ecommerce.ecommerce`
GROUP BY v2ProductName
LIMIT 5;


SELECT 
channelGrouping, pagePathLevel1,
SUM(pageviews) as total_pageviews,
FROM `elegant-theorem-448215-n0.ecommerce.ecommerce`
GROUP BY
channelGrouping, pagePathLevel1;










