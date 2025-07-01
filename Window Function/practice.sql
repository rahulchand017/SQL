use practice;
select * FROM insurance;

-- 1. What are the top 5 patients who claimed the highest insurance amounts?
select PatientID, claim from insurance ORDER BY claim DESC limit 5;
SELECT  `PatientID`, claim,DENSE_RANK() OVER(ORDER BY claim DESC) FROM insurance LIMIT 5;


-- 2. What is the average insurance claimed by patients based on the number of children they have?
SELECT children, round(AVG(claim),2) avg_claims FROM insurance GROUP BY children;


SELECT children, avg_claim FROM (SELECT *, AVG(claim) OVER(PARTITION BY children) as avg_claim,
ROW_NUMBER() OVER(PARTITION BY children) row_num
FROM insurance) t
WHERE t.row_num =1;


-- 3. What is the highest and lowest claimed amount by patients in each region?

SELECT MIN(claim), MAX(claim), region from insurance GROUP BY region;

SELECT region, min_claim, max_claim FROM
            (SELECT *, MIN(claim) OVER(PARTITION BY region) as min_claim, 
            MAX(claim) OVER(PARTITION BY region) as max_claim,
            ROW_NUMBER() OVER(PARTITION BY region) row_num
            FROM insurance) t
where t.row_num =1;


-- 4. What is the percentage of smokers in each age group?



-- 5. What is the difference between the claimed amount of each patient and the first claimed amount of that patient?
SELECT *, 
claim - FIRST_VALUE(claim) OVER() AS difference
FROM insurance;




/*
6. For each patient, calculate the difference between their claimed amount and the average claimed amount of patients 
with the same number of children.
*/

SELECT 
    *,
    claim - AVG(claim) OVER (PARTITION BY children) AS claim_diff
FROM insurance;

SELECT 
    PatientID,
    claim,
    children,
    AVG(claim) OVER (PARTITION BY children) AS avg_claim_per_group,
    claim - AVG(claim) OVER (PARTITION BY children) AS claim_difference
FROM insurance;

-- 7. Show the patient with the highest BMI in each region and their respective rank.
SELECT * FROM (SELECT *,RANK() OVER(PARTITION BY region order BY bmi desc) group_rank,
RANK() OVER(ORDER BY bmi DESC) overall_rank
FROM insurance) t
WHERE t.group_rank = 1;


/*
8. Calculate the difference between the claimed amount of each patient and the claimed amount of the patient who has the 
highest BMI in their region.
*/

SELECT *,
claim - FIRST_VALUE(claim) OVER(PARTITION BY region ORDER BY bmi desc)
from insurance;


/*
For each patient, calculate the difference in claim amount between the patient and the patient with the highest 
claim amount among patients with the smoker status, within the same region. Return the result in descending order difference.
*/

SELECT *, 
(MAX(claim) OVER(PARTITION BY region, smoker) - claim) as claim_diff
FROM insurance
ORDER BY claim_diff desc;



-- For each patient, find the maximum BMI value among their next three records (ordered by age)

/*
General syntax of FRAMES
[ROWS | RANGE] BETWEEN <start> AND <end>
*/

SELECT *,
MAX(bmi) OVER(ORDER BY age ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING)
FROM insurance;



-- For each patient, find the rolling average of the last 2 claims.
SELECT *,
AVG(claim) OVER(ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING)
FROM insurance;




-- 12. Find the first claimed insurance value for male and female patients, 
--     within each region order the data by patient age in ascending order, 
--     and only include patients who are non-diabetic and have a bmi value 
--     between 25 and 30.
WITH filtered_data AS (
	SELECT * FROM insurance
    WHERE diabetic = 'No' AND bmi BETWEEN 25 AND 30
)
SELECT region,gender,first_claim FROM (SELECT *,
FIRST_VALUE(claim) OVER(PARTITION BY region,gender ORDER BY age) AS first_claim,
ROW_NUMBER() OVER(PARTITION BY region,gender ORDER BY age) AS row_num
FROM filtered_data) t
WHERE t.row_num = 1
