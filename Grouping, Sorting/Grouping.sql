/*
The GROUP BY statement groups rows that have the same values into summary rows, like "find the number of customers in each country".

The GROUP BY statement is often used with aggregate functions (COUNT(), MAX(), MIN(), SUM(), AVG()) to group
the result-set by one or more columns.

*/

use course;

--1.  Group smartphones by brand and get the count, average price, max rating, avg screen size and avg battery capacity 
--> group by Animation

select * from smartphones;
SELECT brand_name, count(*) as 'num_phones', avg(price) as avg_price, max(rating),
AVG(battery_capacity) as battery_cap, ROUND(AVG(screen_size),2) as avg_Screen_size 
from smartphones 
GROUP BY brand_name ORDER BY num_phones desc LIMIT 15;



-- Group smartphones by whether they have an NFC and get the average price and rating






























