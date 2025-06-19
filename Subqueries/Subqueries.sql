/*
In SQL, subquery is a query within another query. It is a SELECT statement that is nested inside another
 SELECT, INSERT, UPDATE, or DELETE statement.
 The subquery is executed first, and its result is then used as a parameter or condition for the other query.
*/
CREATE DATABASE subquery;
use subquery;
SELECT MAX(score) FROM movies;

SELECT * FROM movies WHERE score = (SELECT MAX(score) FROM movies);

/*
Outer query
Inner query 
inner query is executed at first then the outer query
*/



/*
Type of Subqueries
1. The result it returns
2. Based on working
*/



/*
1.Return Data
a: Scalar subqueries (scaler value)
b: Row Subqueries (multiple rows and one column)
c: Table subqueries (multiple rows and multiple columns)
*/



/*
2. Working
a: Independent subqueries (inner query is independent)
b: correlated subqueries (inner query is dependent)
*/




-- Independent subquery - Scalar subquery

-- FInd the movie with highest profit[vs order by]
SELECT * FROM movies WHERE (gross- budget) = 
(SELECT MAX(gross-budget) FROM movies );



-- FInd how many movies have a rating > the avg of all the movies (find count of above avg movies)

SELECT COUNT(*) FROM movies WHERE score > (SELECT AVG(score) from movies);


-- Find the highest rated movie of 2000
 
SELECT * FROM movies WHERE year = 2000 and score = (SELECT MAX(score) from movies WHERE year = 2000);


-- Find the highest rated movie among all movies whose number of votes are > the dataset avg votes.
SELECT MAX(score) FROM movies;
SELECT COUNT(*) votes from movies;
SELECT * FROM movies where
score = (SELECT MAX(score) FROM movies WHERE
              votes > (SELECT AVG(votes) FROM movies));


-- Independent subqueries - Row subquery(one col multiple rows)

-- Find all users who never ordered

SELECT * FROM users WHERE user_id NOT IN
(SELECT DISTINCT(user_id) from orders);



-- Find all the movies made by top 3 directors(in term of total gross income)
SELECT * FROM movies where director IN (
SELECT director from movies GROUP BY director
ORDER BY SUM(gross) DESC LIMIT 3);

WITH top_director AS (SELECT director from movies GROUP BY director
ORDER BY SUM(gross) DESC LIMIT 3)
SELECT * FROM movies where director IN(SELECT * FROM top_director);


-- Step 1: Get top 3 directors based on total gross
-- Step 2: Join with movies to get all their movies

SELECT m.*
FROM movies m
JOIN (
    SELECT director
    FROM movies
    GROUP BY director
    ORDER BY SUM(gross) DESC
    LIMIT 3
) AS top_directors
ON m.director = top_directors.director;


-- Find all movies of all those actors whose filmography's avg rating>8.5(take 25000 votes as cutoff)

SELECT * FROM movies where star IN(SELECT star FROM movies
WHERE votes>25000
GROUP BY star HAVING avg(score)>8.5);




-- Table subqueries (multi rows and columns)

-- Find most profitable movie of each year
SELECT * FROM movies where (year, gross-budget) IN
(select year,MAX(gross-budget) as `profit` from movies  GROUP BY year);


-- Find the highest rated movie of each genre votes cutoff of 25000

SELECT * FROM movies WHERE (genre, score) IN
(SELECT genre,MAX(score) `ratings` from movies WHERE votes>25000 GROUP BY genre)
AND votes>25000;



-- FInd highest grossing movie of actor/director combo in terms of total gross income

WITH top_duos as 
(SELECT star, director, max(gross) FROM movies
GROUP BY star, director ORDER BY SUM(gross) DESC limit 5)
SELECT * FROM movies WHERE (star, director, gross) IN (SELECT * from top_duos);


-- Correlated subquery 

-- Find all the movies that have a rating higher than the average rating of movies in the same genre[Animation].

select * from movies m1 WHERE
score > (SELECT AVG(score) FROM movies m2 WHERE m2.genre = m1.genre);
-- comparing movies of same genre


-- FInd the favorite food of each customer


WITH fav_food AS (
  SELECT 
    t2.user_id,
    t1.name,
    t4.f_name,
    COUNT(*) AS frequency
  FROM users t1
  JOIN orders t2 ON t1.user_id = t2.user_id
  JOIN order_details t3 ON t2.order_id = t3.order_id
  JOIN food t4 ON t3.f_id = t4.f_id
  GROUP BY t2.user_id, t1.name, t4.f_name, t3.f_id
)
SELECT *
FROM fav_food f1
WHERE frequency = (
  SELECT MAX(frequency)
  FROM fav_food f2
  WHERE f2.user_id = f1.user_id
);



-- use of subqueries in SELECT
-- get the percentage of votes for each movie compared to the total number of votes.
SELECT * FROM movies m1
WHERE score > (SELECT AVG(score) FROM movies m2 WHERE m2.genre = m1.genre);

SELECT name, (votes/(SELECT sum(votes) FROM movies))*100 FROM movies;



-- Display all movie names, genre, score and avg(score) of genre
SELECT name, genre, score, 
(SELECT AVG(score) FROM movies m2
WHERE m2.genre = m1.genre)
from movies m1;



-- FROM 












