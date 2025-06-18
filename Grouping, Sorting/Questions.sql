use practice;
/*
### **`Problem 1:`**

**The question is:**



### `Problem 2:` 


### **`Problem 3:`**


**The question is:**

Find out the lowest 10th to 30th light sleep percentage records where deep sleep percentage values are between 25 to 45. Display age, light sleep percentage and deep sleep percentage columns only.



### `Problem 4:` Group by on exercise frequency and smoking status and show average deep sleep time, average light sleep time and avg rem sleep time.

* Note the differences in deep sleep time for smoking and non smoking status



### `Problem 5:` Group By on Awekning and show AVG Caffeine consumption, AVG Deep sleep time and AVG Alcohol consumption only for people who do exercise atleast 3 days a week. Show result in descending order awekenings
*/



select * from sleep;
-- Ques1. Find out the average sleep duration of top 15 male candidates who's sleep duration are equal to 7.5 or greater than 7.5.
SELECT AVG(`Sleep duration`) 
FROM sleep 
WHERE `Sleep duration` >= 7.5 AND gender = 'male'  
ORDER BY `Sleep duration` DESC 
LIMIT 15;


/* Ques2: Show avg deep sleep time for both gender. Round result at 2 decimal places.

Note: sleep time and deep sleep percentage will give you, deep sleep time.
*/

SELECT Gender, AVG(`Sleep duration` * (`Deep sleep percentage`/100)) as avg_deep_sleep
FROM sleep GROUP BY Gender;


/* Ques3:

Find out the lowest 10th to 30th light sleep percentage records where deep sleep percentage values are between 25 to 45. 
Display age, light sleep percentage and deep sleep percentage columns only.
*/

SELECT Age,`Light sleep percentage`, `Deep sleep percentage`
FROM sleep
WHERE `Deep sleep percentage` BETWEEN 25 AND 45
ORDER BY `Light sleep percentage` LIMIT 10,20


/*
Ques4: Group by on exercise frequency and smoking status and show average deep sleep time, average light sleep time and avg rem sleep time.

* Note the differences in deep sleep time for smoking and non smoking status
*/

SELECT `Exercise frequency`, `Smoking status`,
AVG(`Sleep duration`*(`Deep sleep percentage`/100)),
AVG(`Sleep duration`*(`REM sleep percentage`/100)),
AVG(`Sleep duration`*(`Light sleep percentage`/100))
FROM sleep
GROUP BY `Exercise frequency`,`Smoking status`
ORDER BY AVG(`Sleep duration`*(`Deep sleep percentage`/100));



/*
QUes5: Group By on Awekning and show AVG Caffeine consumption, AVG Deep sleep time and 
AVG Alcohol consumption only for people who do exercise atleast 3 days a week. Show result in descending order awekenings
*/

SELECT Awakenings, AVG(`Caffeine consumption`), AVG(`Sleep duration` * (`Deep sleep percentage`/100)),
AVG(`Alcohol consumption`) FROM sleep
WHERE `Exercise frequency`>=3 GROUP BY `Awakenings` ORDER BY Awakenings DESC;






-- Power Station Questions

/*
For this question, you can find the details as well as the dataset from
 [here](https://www.kaggle.com/datasets/arvindnagaonkar/power-generation-data).

*/


/*
Question6: 
Display those power stations which have average 'Monitored Cap.(MW)' (display the values) between 1000 and 2000 
and the number of occurrence of the power stations (also display these values) are
greater than 200. Also sort the result in ascending order.
*/


use practice;
SELECT * from powergeneration;
SELECT `Power Station`, AVG(`Monitored Cap.(MW)`)as 'avg_cap', 
COUNT(*) as 'Occurrence'
FROM powergeneration GROUP BY `Power Station`
HAVING ('avg_cap' BETWEEN 1000 and 2000) and Occurrence>200
ORDER BY Avg_cap desc;




/*
Avg Cost of Undergrad College by State(USA) Dataset-
For this question, you can find the detailed dataset 
from [here](https://www.kaggle.com/datasets/kfoster150/avg-cost-of-undergrad-college-by-state).
*/


use practice;
select * from study;
/*
Ques7: Display top 10 lowest "value" State names of which the Year either belong to 2013 or 2017 or 2021 and 
type is 'Public In-State'. Also the number of occurance should be between 6 to 10. 
Display the average value upto 2 decimal places, state names and the occurance of the states.

*/

SELECT State, ROUND(avg(value),2), COUNT(*) as 'frequency'FROM study
WHERE Year IN(2013,2017,2021) AND Type='Public In-state'
GROUP BY State HAVING frequency BETWEEN 6 AND 10 
ORDER BY ROUND(AVG(Value),2) ASC LIMIT 10;


/*
Ques8: Best state in terms of low education cost (Tution Fees) in 'Public' type university.

*/


SELECT State, AVG(Value) FROM study 
WHERE Type LIKE '%Public%'AND Expense LIKE '%Tuition%'
GROUP BY State ORDER BY AVG(Value) LIMIT 1;



/*
QUestion9:  2nd Costliest state for Private education in year 2021. Consider, Tution and Room fee both.

*/
SELECT State, AVG(Value) FROM study
WHERE Year=2021 AND Type LIKE '%Private%'
GROUP BY State ORDER BY AVG(Value) DESC LIMIT 1,1;


