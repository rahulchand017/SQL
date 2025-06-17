CREATE DATABASE practice;
USE practice;

SELECT * FROM insurance;

/*
# Task for SQL DML session

Load this dataset in your database and perform below given tasks.

DataSet - https://docs.google.com/spreadsheets/d/e/2PACX-1vRa1wWwXmzxEvqITxj4OQTeLywlGTTsOTbhSRqKj2lPuGefjlci-DQhgLBPpgWXe8AAUu2WUBqY59X1/pub?gid=1030172542&single=true&output=csv

Look for data description

Kaggle - https://www.kaggle.com/datasets/thedevastator/insurance-claim-analysis-demographic-and-health?select=insurance_data.csv


9. What is the average claim amount for non-smoking female patients who are diabetic?
*/


-- 1. Show records of 'male' patient from 'southwest' region.
SELECT * FROM insurance WHERE gender='male' AND region='southwest';

-- 2. Show all records having bmi in range 30 to 45 both inclusive.

SELECT * FROM insurance WHERE bmi BETWEEN 30 AND 45;


-- 3. Show minimum and maximum blood pressure of diabetic patient who smokes. Make column names as MinBP and MaxBP respectively.
SELECT MAX(bloodpressure) as MaxBP, MIN(bloodpressure) MinBP FROM insurance WHERE smoker='Yes' 


SELECT * FROM insurance;


-- 4. Find no of unique patients who are not from southwest region.
SELECT COUNT(DISTINCT PatientID) AS unique_patients
FROM insurance
WHERE region NOT IN ('southwest');


-- 5. Total claim amount from male smoker.
SELECT SUM(claim) as total_claim FROM insurance WHERE gender='male';


-- 6. Select all records of south region.
SELECT * FROM insurance WHERE region LIKE 'south%';


-- 7. No of patient having normal blood pressure. Normal range[90-120]
SELECT COUNT(DISTINCT(PatientID)) as 'normal bp' FROM insurance WHERE bloodpressure BETWEEN 90 AND 120;



/* 8. No of patient below 17 years of age having normal blood pressure as per below formula -
    - BP normal range = 80+(age in years × 2) to 100 + (age in years × 2)

    - Note: Formula taken just for practice, don't take in real sense.
*/

SELECT COUNT(DISTINCT PatientID) AS normal_bp
FROM insurance WHERE age < 17 AND bloodpressure BETWEEN (80 + age * 2) AND (100 + age * 2);


-- 10. Write a SQL query to update the claim amount for the patient with PatientID = 1234 to 5000.

UPDATE insurance 
SET claim = 5000 WHERE PatientID = 1234;


-- 11. Write a SQL query to delete all records for patients who are smokers and have no children.
DELETE  FROM insurance WHERE smoker='Yes' AND children=0;












