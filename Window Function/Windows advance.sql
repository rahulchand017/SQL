use course;
SELECT * FROM ipl;


-- RANKED 

SELECT * FROM (SELECT `BattingTeam`, batter, SUM(batsman_run) as 'total_runs',
DENSE_RANK() OVER(PARTITION BY `BattingTeam` ORDER BY SUM(batsman_run) desc) 'rank_within_team'
FROM ipl 
GROUP BY `BattingTeam`, batter) t
WHERE t.rank_within_team < 6
ORDER BY t.`BattingTeam`, t.rank_within_team;



-- CUMULATIVE SUM
-- how many runs score by Vkohli in his 50, 100 and 200th match.
SELECT * FROM
                (SELECT CONCAT('Match-', ROW_NUMBER() OVER(ORDER BY `ID`)) 'match_no', 
                SUM(batsman_run) 'runs_scored',
                SUM(SUM(batsman_run)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'career_run'
                FROM ipl 
                WHERE batter = 'V Kohli'
                GROUP BY ID) t
    WHERE match_no = 'Match-50' OR match_no = 'Match-100' OR match_no = 'Match-200';




-- Cumulative average

-- Running Average
SELECT * FROM (SELECT 
CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID) AS CHAR)) AS 'match_no',
SUM(batsman_run) AS 'runs_scored',
SUM(SUM(batsman_run)) OVER w AS 'career_runs',
AVG(SUM(batsman_run)) OVER w AS 'career_avg',
AVG(SUM(batsman_run)) OVER(ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS 'rolling_avg'
FROM ipl
WHERE batter = 'V Kohli'
GROUP BY ID
WINDOW w AS (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) t;


-- Percent of Total
use zomato;
SELECT f_name,
(total_value/SUM(total_value) OVER())*100 AS 'percent_of_total'
FROM (SELECT f_id,SUM(amount) AS 'total_value' FROM orders t1
JOIN order_details t2
ON t1.order_id = t2.order_id
WHERE r_id = 5
GROUP BY f_id) t
JOIN food t3
ON t.f_id = t3.f_id
ORDER BY (total_value/SUM(total_value) OVER())*100 DESC;



-- Percent Change
/* percent change = ((new value- old value)/ old value) X 100

SELECT YEAR(Date), MONTHNAME(Date), SUM(views) as views 
(SUM(views) - LAG(SUM(views)) over(Order BY YEAR(Date), MONTH(Date)))/LAG(SUM(views)) over(Order BY YEAR(Date), MONTH(Date))*100
FROM youtube_views
GROUP BY YEAR(Date), MONTHNAME(Date)
ORDER BY Year(Date), MONTH(Name);
*/

-- Percentiles & Quartiles

USE campusx;

-- Find the median marks of all the students

-- Does not support the direct execution in mysql
SELECT AVG(marks) AS median_marks
FROM (
    SELECT marks,
           ROW_NUMBER() OVER (ORDER BY marks) AS rn,
           COUNT(*) OVER () AS total_rows
    FROM marks
) ranked
WHERE rn IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));


-- Find branch wise median of all the students
SELECT *,
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY marks) OVER (PARTITION BY marks) AS median_marks
FROM marks;


-- Remove an outlier
SELECT * FROM (SELECT *,
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q1',
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q3'
FROM marks) t
WHERE t.marks <= t.Q1 - (1.5*(t.Q3 - t.Q1));

WITH stats AS (
  SELECT 
    AVG(marks) AS mean_val,
    STDDEV(marks) AS std_dev
  FROM marks
)
SELECT *
FROM marks, stats
WHERE ABS(marks - stats.mean_val) <= 2 * stats.std_dev;


/*
-- Step 1: Use a CTE to calculate Q1, Q3, and IQR
WITH percentiles AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY marks) OVER () AS Q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY marks) OVER () AS Q3
  FROM marks
  LIMIT 1
),

-- Step 2: Join the percentiles with the original table and filter outliers
filtered_marks AS (
  SELECT m.*, p.Q1, p.Q3,
         (p.Q3 - p.Q1) AS IQR
  FROM marks m
  CROSS JOIN percentiles p
)

-- Step 3: Final selection without outliers
SELECT student_id, name, branch, marks
FROM filtered_marks
WHERE marks BETWEEN (Q1 - 1.5 * IQR) AND (Q3 + 1.5 * IQR);

*/


/* 
Segmentation
Using NTILE is a technique in SQL for dividing a dataset into equal sized groups based on some criteria or conditions,
and then performing calculations or analysis on each group separately using windows function
*/

select * FROM marks;

SELECT *, NTILE(3) OVER(ORDER BY marks desc) AS 'buckets'
FROM marks;


USE course;

SELECT * FROM smartphones;

SELECT brand_name, model, price,
  CASE 
    WHEN bucket = 1 THEN 'budget'  
    WHEN bucket = 2 THEN 'mid-range'  
    WHEN bucket = 3 THEN 'premium'
    ELSE 'unknown'
  END AS phone_type
FROM (
  SELECT brand_name, model, price, 
         NTILE(3) OVER (ORDER BY price) AS bucket
  FROM smartphones
) t;


use campusx;
-- Cumulative Distribution
-- sum of pdf
SELECT *,
CUME_DIST() OVER(ORDER BY marks)
FROM marks;


use flights;
SELECT * FROM flights;


SELECT * FROM (SELECT source,destination,airline,AVG(price) AS 'avg_fare',
DENSE_RANK() OVER(PARTITION BY source,destination ORDER BY AVG(price)) AS 'rank'
FROM flights
GROUP BY source,destination,airline) t
WHERE t.rank < 2
