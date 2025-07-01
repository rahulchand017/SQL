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





