CREATE DATABASE facebook_ads;

USE facebook_ads;

-- load dataset 

SELECT * FROM facebook_ads;

-- Total Records
SELECT COUNT(*) AS Total_Records
FROM facebook_ads;

-- Unique Campaigns
SELECT DISTINCT xyz_campaign_id
FROM facebook_ads;

-- Unique Age Groups
SELECT DISTINCT age 
FROM facebook_ads;

-- Unique Interest Categories
SELECT DISTINCT interest
FROM facebook_ads ORDER BY interest;



-- Data Cleaning Queries

-- Missing Values
SELECT *
FROM facebook_ads
WHERE age IS NULL;

-- Duplicate Rows
SELECT ad_id, COUNT(*)
FROM facebook_ads
GROUP BY
ad_id
HAVING COUNT(*) > 1;



-- CAMPAIGN ANALYSIS

-- Total Spend by Campaign
SELECT xyz_campaign_id, SUM(spent) AS Total_Spend
FROM facebook_ads
GROUP BY xyz_campaign_id
ORDER BY Total_Spend DESC;

-- Total Clicks by Campaign
SELECT xyz_campaign_id, SUM(clicks) AS Total_Clicks
FROM facebook_ads
GROUP BY xyz_campaign_id
ORDER BY Total_Clicks DESC;

-- Total Approved Conversion
SELECT xyz_campaign_id, SUM(Approved_Conversion) As Approved
FROM facebook_ads
GROUP BY xyz_campaign_id
ORDER BY Approved DESC;



-- AUDIENCE ANALYSIS

-- Best Age group
SELECT age, SUM(Approved_Conversion) AS Approved
FROM facebook_ads
GROUP BY age
ORDER BY Approved DESC;

-- Gender Performance
SELECT gender, SUM(Approved_Conversion) AS Approved
FROM facebook_ads
GROUP BY gender
ORDER BY Approved DESC;

-- Interest Analysis
SELECT interest, SUM(Approved_Conversion) AS Approved
FROM facebook_ads
GROUP BY interest
ORDER BY Approved DESC;



-- COST ANALYSIS

-- Average Spend
SELECT AVG(spent)
FROM facebook_ads;

-- Highest Spending ads
SELECT ad_id, spent
FROM facebook_ads
ORDER BY spent DESC
LIMIT 10;

-- Lowest Spending ads
SELECT ad_id, spent
FROM facebook_ads
ORDER BY spent ASC
LIMIT 10;

-- CLICK ANALYSIS

-- Top Clicked Ads
SELECT ad_id, clicks
FROM facebook_ads
ORDER BY clicks DESC
LIMIT 10;

-- Lowest Clicked ads
SELECT ad_id, clicks
FROM facebook_ads
ORDER BY clicks ASC
LIMIT 10;



-- CONVERSION ANALYSIS

-- Highest Approved Conversion
SELECT ad_id, Approved_Conversion
FROM facebook_ads
ORDER BY Approved_Conversion DESC
LIMIT 10;

-- Highest Total Conversion
SELECT ad_id, Total_Conversion
FROM facebook_ads
ORDER BY Total_Conversion DESC
LIMIT 10;



-- MULTI VARIABLE ANALYSIS

-- Age x Gender
SELECT age, gender, SUM(Approved_Conversion) AS Conversion
FROM facebook_ads
GROUP BY age, gender
ORDER BY Conversion DESC;

-- Campaign x Age
SELECT xyz_campaign_id, age, SUM(Approved_Conversion) AS Conversion
FROM facebook_ads
GROUP BY xyz_campaign_id, age
ORDER BY Conversion DESC;

-- Campaign x Gender 
SELECT xyz_campaign_id, gender, SUM(Approved_Conversion) AS Conversion
FROM facebook_ads
GROUP BY xyz_campaign_id, gender
ORDER BY Conversion DESC;



-- RANKING QUERIES

-- Rank Campaign by Spend
SELECT xyz_campaign_id, SUM(spent) AS Total_Spend,
RANK() OVER(ORDER BY SUM(spent) DESC) AS Spend_Rank
FROM facebook_ads
GROUP BY xyz_campaign_id;

-- Rank Ads by Clicks
SELECT ad_id, clicks,
RANK() OVER(ORDER BY clicks DESC) AS Click_Rank
FROM facebook_ads;


