CREATE DATABASE zomato;
use zomato;

-- Count number of rows
SELECT COUNT(*) from users;


-- return a random record
SELECT * FROM users ORDER BY rand() limit 5;

-- find null values
SELECT * FROM orders WHERE restaurant_rating IS NULL;
-- UPDATE orders SET restaurant_value=0 where restaurant_rating IS NULL;


-- Find order placed by each customer
SELECT t2.name, COUNT(*) AS count_orders
FROM orders t1
JOIN users t2 ON t1.user_id = t2.user_id
GROUP BY t2.user_id, t2.name;


-- Find restaurants with most no of menu items
SELECT t1.r_name, COUNT(*) as menu_items from restaurants t1 
JOIN menu t2 ON t1.r_id = t2.r_id 
GROUP BY t1.r_name;





-- Find no of votes and average rating for all the restaurants
SELECT r_name, COUNT(*) as num_votes, round(AVG(restaurant_rating),2) as `ratings`
FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
WHERE restaurant_rating IS NOT NULL
GROUP BY t1.r_id, r_name;



-- Find the food that is being sold in most restaurants
SELECT f_name, COUNT(*) from menu t1
JOIN food t2 
ON t1.f_id = t2.f_id GROUP BY t1.f_id, f_name
ORDER BY COUNT(*) desc limit 1;


-- find restaurant with max revenue in a given month
SELECT r_name, SUM(amount) `revenue` FROM orders t1 JOIN restaurants t2
ON t1.r_id = t2.r_id
WHERE MONTHNAME(DATE(date)) ='May'
GROUP BY t1.r_id, r_name
ORDER BY revenue DESC LIMIT 1;


-- Month by month revenue for particular months
SELECT r_name, SUM(amount) `revenue` FROM orders t1
JOIN restaurants t2 
ON t1.r_id = t2.r_id 
WHERE r_name = 'box8';


-- Restaurants with aggregate revenue > 1500
SELECT r_name, SUM(amount) as revenue FROM orders t1 
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t1.r_id, r_name
HAVING revenue>1500;


-- Find customers who have never ordered
SELECT user_id, name FROM users
EXCEPT
SELECT t1.user_id, name FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id;


-- Find order details of a particular customer in a given date range
SELECT t2.name, t1.date  FROM orders t1 JOIN users t2
ON t1.user_id = t2.user_id 
GROUP BY t1.user_id, t2.name;

SELECT t4.r_name, t1.order_id, f_name, date FROM orders t1
JOIN order_details t2 
ON t1.order_id = t2.order_id
JOIN food t3 
ON t2.f_id = t3.f_id
JOIN restaurants t4
ON t1.r_id = t4.r_id
WHERE user_id =1 AND DATE BETWEEN '2022-05-15' AND '2022-06-15'



-- Customers favorite food (incomplete)
SELECT t1.user_id, t3.f_id, COUNT(*) `counts` FROM users t1
JOIN orders t2
ON t1.user_id = t2.user_id
JOIN order_details t3
ON t2.order_id = t3.order_id
GROUP BY t1.user_id, t3.f_id
ORDER BY counts DESC;



-- Find most costly restaurants (avg price/dish)
SELECT * FROM restaurants t1 JOIN 
orders t2 ON t1.r_id = t2.r_id
ORDER BY amount DESC
LIMIT 1;


SELECT r_name, SUM(price)/COUNT(*) `avg_price` FROM menu t1
JOIN restaurants t2 
ON t1.r_id = t2.r_id
GROUP BY t1.r_id, r_name
ORDER BY avg_price DESC LIMIT 1;



-- Find delivery partner compensation using the formula (deliveries * 100 + 1000 * avg_rating)
SELECT partner_name, COUNT(*)*100 + AVG(delivery_rating)* 1000 as salary
FROM orders t1
JOIN delivery_partner t2
ON t1.partner_id = t2.partner_id
GROUP BY t1.partner_id, partner_name
ORDER BY salary DESC;



-- Correlation between two columns  delivery time and total rating
SELECT CORR(delivery_time, delivery_rating + restaurant_rating) AS correlation
FROM orders;



-- Find all veg restaurant
SELECT t3.r_name, t2.f_name FROM menu t1
JOIN food t2
on t1.f_id = t2.f_id
JOIN restaurants t3 
ON t1.r_id = t3.r_id
WHERE t2.type = 'Veg';

SELECT r.r_name
FROM restaurants r
JOIN menu m ON r.r_id = m.r_id
JOIN food f ON m.f_id = f.f_id
GROUP BY r.r_id, r.r_name
HAVING SUM(f.type = 'Non-Veg') = 0;
-- HAVING MIN(type) = 'Veg' AND MAX(type)='Veg;



-- Find min and max value for all the orders
SELECT name, MIN(amount), MAX(amount), AVG(amount) FROM orders t1
JOIN users t2 
ON t1.user_id = t2.user_id
GROUP BY t1.user_id, name;


