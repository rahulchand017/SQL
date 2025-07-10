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


