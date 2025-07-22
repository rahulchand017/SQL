SELECT DISTINCT(Destination) FROM flights
            UNION
            SELECT DISTINCT(Source) FROM flights;

SELECT * FROM flights
WHERE `Source` = 'Banglore' AND `Destination`='Delhi';

SELECT Airline, COUNT(*) FROM flights
GROUP BY `Airline`;


-- busiest airport
SELECT SOURCE, COUNT(*) FROM(SELECT Source FROM flights
UNION ALL
SELECT `Destination` FROM flights)t
GROUP BY t.`Source`
ORDER BY COUNT(*) DESC;

SELECT Date_of_Journey, COUNT(*) FROM flights
GROUP BY `Date_of_Journey`;