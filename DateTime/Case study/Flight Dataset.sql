CREATE DATABASE dash;
-- used in Python sql data

use flights;

SELECT * FROM flights;

-- Find the month with most no of flight
SELECT MONTHNAME(Date_of_Journey), count(*) 
from flights
GROUP BY MONTHNAME(Date_of_Journey)
ORDER BY COUNT(*) DESC limit 1;


--  Which week day is the most costly
SELECT DAYNAME(Date_of_Journey), AVG(price) 
FROM flights
GROUP BY DAYNAME(Date_of_Journey)
ORDER BY AVG(price) DESC limit 1;


-- Find the no of indigo flights every month
SELECT MONTHNAME(Date_of_journey), COUNT(*) FROM flights
WHERE airline = 'Indigo'
GROUP BY MONTHNAME(Date_of_journey), MONTH(Date_of_journey) 
ORDER BY MONTH(Date_of_journey) asc;


-- find list of all flights that depart between 10AM and 2PM from Delhi to Bangalore. 
SELECT DISTINCT source FROM flights;

SELECT * FROM flights
WHERE
    source = 'Banglore' AND
    Destination = 'Delhi' AND
    Dep_Time > '10:00' AND Dep_Time < '14:00';



-- Find the num of flights departed from weekends
SELECT COUNT(*) FROM flights 
where source = 'Banglore' AND
DAYNAME(`Date_of_Journey`) IN ('saturday', 'sunday');


-- Calculate the arrival time for all flights by adding the duration to the departure time.
ALTER Table flights
ADD COLUMN departure DATETIME;

UPDATE flights
SET departure =  STR_TO_DATE(CONCAT(Date_of_journey, ' ', dep_time), '%Y-%m-%d %H:%i');

SELECT * FROM flights;

ALTER Table flights
ADD COLUMN duration_mins INTEGER,
ADD COLUMN arrival DATETIME;

/*
SELECT Duration,
REPLACE(SUBSTRING_INDEX(duration,' ',1),'h','')*60 + 
CASE
	WHEN SUBSTRING_INDEX(duration,' ',-1) = SUBSTRING_INDEX(duration,' ',1) THEN 0
    ELSE REPLACE(SUBSTRING_INDEX(duration,' ',-1),'m','')
END AS 'mins'
FROM flights;

UPDATE flights
SET duration_mins = REPLACE(SUBSTRING_INDEX(duration,' ',1),'h','')*60 + 
CASE
	WHEN SUBSTRING_INDEX(duration,' ',-1) = SUBSTRING_INDEX(duration,' ',1) THEN 0
    ELSE REPLACE(SUBSTRING_INDEX(duration,' ',-1),'m','')
END;
*/

UPDATE flights
SET duration_mins = Duration;


SELECT * FROM flights;

UPDATE flights
SET arrival = DATE_ADD(departure,INTERVAL duration_mins MINUTE);

SELECT * FROM flights;

SELECT TIME(arrival) FROM flights;


-- Find the number of flights which travel on multiple dates
SELECT COUNT(*) FROM flights
WHERE date(departure) != DATE(arrival);


-- calculate the average duration of flight between all city pairs4
SELECT `Source`, `Destination`, AVG(`Duration`) FROM flights
GROUP BY `Source`, `Destination`;

-- Find all flights which departed before midnight, but reached after midnight with 0 stops

SELECT * FROM flights
WHERE Total_Stops = 0 AND
date(Departure) != DATE(arrival);

/*
SELECT * FROM flights
WHERE Total_Stops = 0 AND
date(Departure) < DATE(arrival);
*/

-- Find quarter wise number of flights for each airline
SELECT airline, QUARTER(departure), COUNT(*)
FROM flights
GROUP BY airline, QUARTER(departure);


-- Find the longest flight distance between cities in term of time in india
SELECT airline, source, `Destination`, duration_mins 
FROM flights
GROUP BY `Airline`, source, `Destination`,  duration_mins
ORDER BY duration_mins desc LIMIT 1;


-- Average time duration for flights that have 1 stop vs more than 1 stop
WITH temp_table AS (SELECT *,
CASE 
	WHEN total_stops = 'non-stop' THEN 'non-stop'
    ELSE 'with stop'
END AS 'temp'
FROM flights)
SELECT temp,
TIME_FORMAT(SEC_TO_TIME(AVG(duration_mins)*60),'%kh %im') AS 'avg_duration',
AVG(price) AS 'avg_price'
FROM temp_table
GROUP BY temp;


-- 14. Find all Air India flights in a given date range origin from delhi
-- 1st Mar 2019 to 10th Mar 2019 
SELECT * FROM flights
WHERE source = 'Delhi' AND
DATE(departure) BETWEEN '2019-03-01' AND '2019-03-10';


-- Find the longest flight of each airline
SELECT airline,
TIME_FORMAT(SEC_TO_TIME(MAX(duration_mins)*60),'%kh %im') AS 'max_duration'
FROM flights
GROUP BY airline
ORDER BY MAX(duration_mins) DESC;


-- Find all the pair of cities having average time duration > 3 hours;
SELECT source,destination,
TIME_FORMAT(SEC_TO_TIME(AVG(duration_mins)*60),'%kh %im') AS 'avg_duration' FROM flights
GROUP BY source,destination
HAVING AVG(duration_mins) > 180;


-- 	17. Make a weekday vs time grid showing frequency of flights from Banglore and Delhi

/*
SELECT DAYNAME(departure),
SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12PM'
FROM flights
WHERE source = 'Banglore' AND destination = 'Delhi'
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;
*/


SELECT 
  DAYNAME(departure) AS weekday,
  SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
  SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
  SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
  SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12AM'
FROM flights
WHERE source = 'Banglore' AND destination = 'Delhi'
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 	18. Make a weekday vs time grid showing avg flight price from Banglore and Delhi

SELECT DAYNAME(departure) weekday,
AVG(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN price ELSE NULL END) AS '12AM - 6AM',
AVG(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN price ELSE NULL END) AS '6AM - 12PM',
AVG(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN price ELSE NULL END) AS '12PM - 6PM',
AVG(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN price ELSE NULL END) AS '6PM - 12PM'
FROM flights
WHERE source = 'Banglore' AND destination = 'Delhi'
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');


