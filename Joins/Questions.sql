use practice;
SELECT ;


-- Ques1. Find out top 10 countries' which have maximum A and D values.



SELECT * FROM (SELECT Country, A FROM country_ab 
ORDER BY A DESC limit 10) A 
JOIN
(SELECT Country, D FROM country_cd 
country_cd ORDER BY D DESC limit 10) D
ON A.country = D.country;
-- or bhi bhoot tha, long answer still in progress

/*

Ques2.  Find out highest CL value for 2020 for every region. Also sort the result in descending order. 
Also display the CL values in descending order.
*/
SELECT Region, MAX(CL) FROM country_cl t1 JOIN country_ab t2
ON t1.country = t2.country WHERE t1.Edition = 2020
GROUP BY Region
ORDER BY max(CL) DESC;




CREATE DATABASE sales;
use sales;

-- Ques3: Top 5 most sold product

SELECT t2.Name, SUM(t1.Quantity) AS total_quantity 
FROM sales1 t1
JOIN products t2 ON t1.ProductID = t2.ProductID
GROUP BY t1.ProductID, t2.Name
ORDER BY total_quantity DESC
LIMIT 5;



-- Ques4. Find sales man who sold most no of products.
SELECT 
    t1.SalesPersonID,
    t2.FirstName,
    t2.LastName,
    SUM(t1.Quantity) AS num_sold
FROM sales1 t1
JOIN employees t2 ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID, t2.FirstName, t2.LastName
ORDER BY num_sold DESC
LIMIT 5;


/*
Ques5: Sales man name who has most no of unique customer.

Q-6: Sales man who has generated most revenue. Show top 5.

Q-7: List all customers who have made more than 10 purchases.

Q-8 : List all salespeople who have made sales to more than 5 customers.

Q-9: List all pairs of customers who have made purchases with the same salesperson.


*/
















