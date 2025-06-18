-- 1. Inner Join
-- 2. Full Outer Join
-- 3. Cross Join
-- 4. Left Join
-- 5. Right Join
-- 6. Self Join

CREATE DATABASE flipkart;
CREATE DATABASE sql_cx;

use sql_cx;
SELECT * FROM students;


/* CROSS JOIN
A = {1,2}
B = {3,4}
A*B= {(1,3),(1,4),(2,3),(2,4)}

*/


SELECT * FROM `groups`;
SELECT * FROM membership;


-- CROSS JOIN
SELECT * FROM users t1 CROSS JOIN sql_cx.groups t2;


-- INNER JOIN
SELECT * FROM membership t1 JOIN users1  t2 ON t1.user_id = t2.user_id;


-- LEFT JOIN
SELECT * FROM membership t1 
LEFT JOIN users t2 
ON t1.user_id = t2.user_id;




-- RIGHT JOIN
SELECT * FROM membership t1 
RIGHT  JOIN users t2 
ON t1.user_id = t2.user_id;

-- FULL OUTER JOIN
SELECT * FROM 

/* 
SET OPERATIONS
1. UNION:- Combine all the unique value without duplicates.
2. UNION ALL
3. INTERSECTION
4. EXCEPT :- Element of table 1 will occur without common table1 except table 2
 vice versa when table2 except table1
*/


use sql_cx;
SELECT* FROM person1 
UNION 
SELECT * FROM person2;


SELECT* FROM person1 
EXCEPT 
SELECT * FROM person2;



-- FULL OUTER JOIN
SELECT * from membership t1 LEFT JOIN
users t2 on t1.user_id = t2.user_id
UNION
SELECT * from membership t1 RIGHT JOIN
users t2 on t1.user_id = t2.user_id;



-- SELF join
SELECT * FROM users1 j1 join users1 j2 ON
j1.emergency_contact = j2.user_id;


SELECT * FROM students t1 JOIN class t2 ON
t1.class_id = t2.class_id AND t1.enrollment_year = t2.class_year;


use flipkart;
-- JOINING in more than 2 table
SELECT * FROM category;

-- FIND order name and corresponding category name
SELECT * FROM order_details t1 JOIN orders t2
 ON t1.order_id = t2.order_id
 JOIN users t3 ON
t2.user_id = t3.user_id;



SELECT t1.order_id, t1.amount FROM order_details t1 JOIN orders t2
 ON t1.order_id = t2.order_id
 JOIN users t3 ON
t2.user_id = t3.user_id;



-- Find order_id name and city by joining user and orders.
SELECT t1.order_id, t2.name, t2.city FROM
orders t1 JOIN users t2
ON t1.user_id = t2.user_id 



-- Find order_id, product_category by joining order_details and category

SELECT t1.order_id, t2.vertical FROM
order_details t1 JOIN category t2
ON t1.category_id = t2.category_id;



-- Filtering rows
-- Find all the orders came from pune
SELECT * FROM orders t1 JOIN users t2
ON t1.user_id = t2.user_id WHERE t2.city = 'Pune';


-- Find all profitable orders
SELECT t1.order_id, SUM(t2.profit) FROM orders t1 JOIN
order_details t2 ON t1.order_id = t2.order_id
GROUP BY t1.order_id HAVING SUM(t2.profit) >0;


-- FIND the customer with maximum no of orders
SELECT name, COUNT(*)
FROM orders t1 JOIN users t2 
ON t1.user_id = t2.user_id 
GROUP BY t2.name ORDER BY COUNT(*) DESC;



-- What is the most profitable state
SELECT state, SUM(profit) FROM orders t1
JOIN order_details t2 ON t1.order_id = t2.order_id
JOIN users t3 ON t1.user_id = t3.user_id
GROUP BY state ORDER BY SUM(profit) DESC limit 1;

