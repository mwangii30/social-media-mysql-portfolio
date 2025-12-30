SELECT *
FROM social_media_usage
;

-- Find out how many participants filled the questionnaire

SELECT COUNT(*)
FROM social_media_usage
;

-- There were 481 participants

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'social_media_usage'
  AND TABLE_SCHEMA = 'jamesdb';

-- Finding out if There is a correlation between age and 
-- Changing the column names

WITH survey_cte AS
 (
  SELECT
    Timestamp,
    Age,
    Social_app,
    CASE 
    WHEN Gender = 'Male' THEN 'male'
    WHEN Gender = 'Female' THEN 'female'
    ELSE 'Other'
    END AS Gender,
    IF(LOWER(Social_app) LIKE '%tiktok%', TRUE, FALSE) AS use_tiktok,
    IF(LOWER(Social_app) LIKE '%facebook%', TRUE, FALSE) AS use_facebook,
    IF(LOWER(Social_app) LIKE '%twitter%', TRUE, FALSE) AS use_twitter,
    IF(LOWER(Social_app) LIKE '%instagram%', TRUE, FALSE) AS use_instagram,
    IF(LOWER(Social_app) LIKE '%discord%', TRUE, FALSE) AS use_discord,
    IF(LOWER(Social_app) LIKE '%youtube%', TRUE, FALSE) AS use_youtube,
    IF(LOWER(Social_app) LIKE '%reddit%', TRUE, FALSE) AS use_reddit,
    IF(LOWER(Social_app) LIKE '%pinterest%', TRUE, FALSE) AS use_pinterest
    FROM social_media_usage
    )
    SELECT *
    FROM survey_cte
    ;
    
  -- Find out which social media application is heavily used
  
  WITH survey_cte AS
 (
  SELECT
    Timestamp,
    Age,
    Social_app,
    CASE 
    WHEN Gender = 'Male' THEN 'male'
    WHEN Gender = 'Female' THEN 'female'
    ELSE 'Other'
    END AS Gender,
    IF(LOWER(Social_app) LIKE '%tiktok%', TRUE, FALSE) AS use_tiktok,
    IF(LOWER(Social_app) LIKE '%facebook%', TRUE, FALSE) AS use_facebook,
    IF(LOWER(Social_app) LIKE '%twitter%', TRUE, FALSE) AS use_twitter,
    IF(LOWER(Social_app) LIKE '%instagram%', TRUE, FALSE) AS use_instagram,
    IF(LOWER(Social_app) LIKE '%discord%', TRUE, FALSE) AS use_discord,
    IF(LOWER(Social_app) LIKE '%youtube%', TRUE, FALSE) AS use_youtube,
    IF(LOWER(Social_app) LIKE '%reddit%', TRUE, FALSE) AS use_reddit,
    IF(LOWER(Social_app) LIKE '%pinterest%', TRUE, FALSE) AS use_pinterest
    FROM social_media_usage
    )
    SELECT
    ROUND((SUM(use_tiktok) / COUNT(*)) * 100, 2) AS tiktok_percentage,
    ROUND((SUM(use_facebook) / COUNT(*)) * 100,2) AS facebook_percentage,
    ROUND((SUM(use_twitter) / COUNT(*)) * 100,2) AS twitter_percentage,
    ROUND((SUM(use_instagram) / COUNT(*)) * 100,2) AS instagram_percentage,
    ROUND((SUM(use_discord) / COUNT(*)) * 100,2) AS discord_percentage,
    ROUND((SUM(use_youtube) / COUNT(*)) * 100,2) AS youtube_percentage,
    ROUND((SUM(use_reddit) / COUNT(*)) * 100,2) AS reddit_percentage,
    ROUND((SUM(use_pinterest) / COUNT(*)) * 100,2) AS pinterest_percentage
    FROM survey_cte
    ;
    
    -- What is the age distribution of the respondents
    
    With Age_cte AS
    (
		SELECT
        Age,
        Occupation,
        CASE
        WHEN Age < 29 THEN 'Gen Z'
        WHEN Age BETWEEN 29 AND 45 THEN 'Millenial' 
        WHEN Age BETWEEN 45 AND 61 THEN 'Gen X'
        WHEN Age BETWEEN 61 AND 70 THEN 'Boomers'
        WHEN Age > 70 THEN 'Post War'
        ELSE 'Other'
        END AS Age_bracket
        FROM social_media_usage
        )
        SELECT Age_bracket, count(Age_bracket) As count
        FROM Age_cte
        group by Age_bracket
        ;
	-- As the age increases the social media usage decreases. Negative Correlation.
    
    -- How does screen time vary with age?

SELECT Screen_time
FROM social_media_usage
group by Screen_time
;
  
    With ScreenTime_cte AS
    (
		SELECT
        Age,
        Occupation,
        CASE
        WHEN Age < 29 THEN 'Gen Z'
        WHEN Age BETWEEN 29 AND 45 THEN 'Millenial' 
        WHEN Age BETWEEN 45 AND 61 THEN 'Gen X'
        WHEN Age BETWEEN 61 AND 70 THEN 'Boomers'
        WHEN Age > 70 THEN 'Post War'
        ELSE 'Other'
        END AS Age_bracket,
        CASE 
        WHEN Screen_time ='Between 2 and 3 hours' THEN 2.5
        WHEN Screen_time ='More than 5 hours' THEN 5.5
        WHEN Screen_time ='Between 3 and 4 hours' THEN 3.5
        WHEN Screen_time ='Less than an Hour' THEN 1
        WHEN Screen_time ='Between 1 and 2 hours' THEN 1.5
        ELSE 'Other'
        END AS Screen_time
        FROM social_media_usage
        )
        SELECT Age_bracket, count(age_bracket), ROUND(avg(Screen_time),2) AS Avg_Screen_time
        FROM ScreenTime_cte
        GROUP BY Age_bracket
        ;
        
	-- Boomers have the highest screen time. However, it is important to note that the average screen time based on the survey may be wrong since the number of participants
    -- for each age bracket is different
    
    -- Does relationship status affect social media usage?
    
    SELECT Relationship AS relationship_status, count(Relationship) as Num
    FROM social_media_usage
    GROUP BY Relationship
    ORDER BY Num DESC
    ;
    
    SELECT Screen_time
FROM social_media_usage
group by Screen_time
;
  
    With ScreenTime_cte AS
    (
		SELECT
        Relationship,
        CASE 
        WHEN Screen_time ='Between 2 and 3 hours' THEN 2.5
        WHEN Screen_time ='More than 5 hours' THEN 5.5
        WHEN Screen_time ='Between 3 and 4 hours' THEN 3.5
        WHEN Screen_time ='Less than an Hour' THEN 1
        WHEN Screen_time ='Between 1 and 2 hours' THEN 1.5
        ELSE 'Other'
        END AS Screen_time
        FROM social_media_usage
        )
        SELECT relationship, count(relationship), ROUND(avg(Screen_time),2) AS Avg_Screen_time
        FROM ScreenTime_cte
        GROUP BY relationship
        ;

-- From the two queries we can conclude single people use social media the most in terms of how many of them and also the average screen time

-- Does occupation determine the average screen tme?

 SELECT Screen_time
FROM social_media_usage
group by Screen_time
;
  
    With ScreenTime_cte AS
    (
		SELECT
        Occupation,
        CASE 
        WHEN Screen_time ='Between 2 and 3 hours' THEN 2.5
        WHEN Screen_time ='More than 5 hours' THEN 5.5
        WHEN Screen_time ='Between 3 and 4 hours' THEN 3.5
        WHEN Screen_time ='Less than an Hour' THEN 1
        WHEN Screen_time ='Between 1 and 2 hours' THEN 1.5
        ELSE 'Other'
        END AS Screen_time
        FROM social_media_usage
        )
        SELECT Occupation, count(occupation), ROUND(avg(Screen_time),2) AS Avg_Screen_time
        FROM ScreenTime_cte
        GROUP BY Occupation
        ;
        
        -- Students have the highest average screen time. People Who are working have the lowest.
        
        -- Showing how social media usage compares with levels of distraction and sleplessness
        
        With ScreenTime_cte AS
    (
		SELECT
        Screen_time,
        Distracted,
        CASE 
        WHEN Screen_time ='Between 2 and 3 hours' THEN 2.5
        WHEN Screen_time ='More than 5 hours' THEN 5.5
        WHEN Screen_time ='Between 3 and 4 hours' THEN 3.5
        WHEN Screen_time ='Less than an Hour' THEN 1
        WHEN Screen_time ='Between 1 and 2 hours' THEN 1.5
        ELSE 'Other'
        END AS Screen_time_avg,
         CASE
        WHEN distracted = 1 THEN 'Not at all distracted'
        WHEN distracted = 2 THEN 'Slightly distracted'
        WHEN distracted = 3 THEN 'Moderately distracted'
        WHEN distracted = 4 THEN 'Very distracted'
        WHEN distracted = 5 THEN 'Extremely distracted'
        ELSE 'Other'
        END AS distraction_level
        FROM social_media_usage
        )
        SELECT ROUND(AVG(Screen_time_avg),2) AS Screen_time, distraction_level
        FROM ScreenTime_cte
        GROUP BY distraction_level
       ;
       
        With ScreenTime_cte AS
    (
		SELECT
        Screen_time,
        Sleep_issues,
        CASE 
        WHEN Screen_time ='Between 2 and 3 hours' THEN 2.5
        WHEN Screen_time ='More than 5 hours' THEN 5.5
        WHEN Screen_time ='Between 3 and 4 hours' THEN 3.5
        WHEN Screen_time ='Less than an Hour' THEN 1
        WHEN Screen_time ='Between 1 and 2 hours' THEN 1.5
        ELSE 'Other'
        END AS Screen_time_avg,
         CASE
        WHEN distracted = 1 THEN 'Not at all distracted'
        WHEN distracted = 2 THEN 'Slightly distracted'
        WHEN distracted = 3 THEN 'Moderately distracted'
        WHEN distracted = 4 THEN 'Very distracted'
        WHEN distracted = 5 THEN 'Extremely distracted'
        ELSE 'Other'
        END AS distraction_level
        FROM social_media_usage
        )
        SELECT ROUND(AVG(Screen_time_avg),2) AS Screen_time, distraction_level
        FROM ScreenTime_cte
        GROUP BY distraction_level
       ;
       
-- It is evident that the level of distraction has a positive correlation with the amount of screentime.

SELECT *
FROM social_media_usage
;