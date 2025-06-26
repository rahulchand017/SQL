use practice;


/*
Display the names of athletes who won a gold medal in the 2008 Olympics and whose height is greater than the average 
height of all athletes in the 2008 Olympics.

*/
SELECT * FROM athlete_events
WHERE Year = 2008 AND
`Medal`= 'Gold' AND
`Height`> (SELECT AVG(`Height`)FROM athlete_events WHERE year=2008);


/*
Display the names of athletes who won a medal in the sport of basketball in the 2016 Olympics and whose weight is 
less than the average weight of all athletes who won a medal in the 2016 Olympics.
*/
SELECT name from athlete_events
WHERE `Year`=2016 AND `Sport` = 'Basketball'
AND `Medal` IS NOT NULL AND
`Height`<(SELECT AVG(`Height`) FROM athlete_events WHERE `Year`=2016 AND `Medal` IS NOT NULL);



-- Display the names of all athletes who have won a medal in the sport of swimming in both the 2008 and 2016 Olympics.
SELECT name FROM athlete_events WHERE `Sport` = 'Swimming' AND
`Year` IN (2008 ,2016) AND
`Medal` is not null; 



-- Display the names of all countries that have won more than 50 medals in a single year.


SELECT country, YEAR, count(*) FROM athlete_events
WHERE `Medal` IS not NULL AND country is not null
GROUP BY country, `Year`
HAVING count(*)>50
ORDER BY year;




-- Display the names of all athletes who have won medals in more than one sport in the same year.
SELECT DISTINCT name from athlete_events WHERE ID in(
    SELECT DISTINCT `ID` FROM athlete_events
    WHERE `Medal` is not null GROUP BY id, year, `Sport`
    having count(Medal)>1
    order by COUNT(`Medal`) desc
)




-- What is the average weight difference between male and female athletes in the Olympics who have won a medal in the same event?
SELECT AVG(A.Sex- B.Sex) from (SELECT * FROM athlete_events WHERE `Medal` is not null) a
JOIN(SELECT * FROM athlete_events WHERE `Medal`IS NOT NULL)B
ON A.EVENT = B.EVENT AND
A.Sex != B.Sex;




/*
How many patients have claimed more than the average claim amount for patients who are smokers and have at least one child, 
and belong to the southeast region?
*/

SELECT COUNT(claim) FROM insurance_data WHERE claim> (SELECT AVG(claim) FROM insurance_data 
        where children >=1 AND smoker = 'Yes' AND region='southwest');


/*

How many patients have claimed more than the average claim amount for patients who are not smokers and have a BMI greater than 
the average BMI for patients who have at least one child?
*/
SELECT COUNT(claim) FROM insurance_data WHERE claim> 
                (SELECT AVG(claim) FROM insurance_data WHERE smoker='No' AND
                        bmi> (SELECT AVG(BMI) FROM insurance_data WHERE children>=1));




/*

How many patients have claimed more than the average claim amount for patients who have a BMI greater 
than the average BMI for patients who are diabetic, have at least one child, and are from the southwest region?
*/
SELECT COUNT(claim) FROM insurance
WHERE claim > (SELECT AVG(claim) FROM insurance WHERE
			   bmi > (SELECT AVG(bmi) FROM insurance
					  WHERE children >= 1 AND
                      diabetic = 'Yes' AND
                      region = 'southwest'));



/*
What is the difference in the average claim amount between patients who are smokers and patients who are 
non-smokers, and have the same BMI and number of children?
*/

SELECT AVG(A.claim - B.claim) FROM insurance A
JOIN insurance B
ON A.bmi = B.bmi
AND A.smoker != B.smoker 
AND A.children = B.children


SELECT bmi, children, AVG(claim) AS smoker_avg_claim, (
    SELECT AVG(claim)
    FROM insurance_data AS non_smoker
    WHERE non_smoker.bmi = smoker.bmi
    AND non_smoker.children = smoker.children
    AND non_smoker.smoker = 'No'
) AS non_smoker_avg_claim, AVG(claim) - (
    SELECT AVG(claim)
    FROM insurance_data AS non_smoker
    WHERE non_smoker.bmi = smoker.bmi
    AND non_smoker.children = smoker.children
    AND non_smoker.smoker = 'No'
) AS claim_diff
FROM insurance_data AS smoker
WHERE smoker.smoker = 'Yes'
GROUP BY smoker.bmi, smoker.children
having claim_diff is not null
ORDER BY bmi, children;







