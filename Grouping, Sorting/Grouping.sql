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
SELECT has_nfc, AVG(price) as 'avg_price', avg(rating) as avg_rating
from smartphones GROUP BY has_nfc;


-- Group smartphones by the brand and processor brand and get the count of models and the average primary camera resolution.
SELECT brand_name, os, processor_brand, COUNT(*) as 'num phones', 
ROUND(AVG(primary_camera_rear)) as 'avg camera resolution' FROM smartphones
GROUP BY brand_name, processor_brand, os;

-- Top 5 costly smartphone brands
SELECT brand_name, ROUND(AVG(price)) as avg_price from smartphones
GROUP BY brand_name ORDER BY avg_price DESC limit 5;


-- Which brand make the smallest screen size
SELECT brand_name, round(avg(screen_size)) as avg_screen_size FROM smartphones
GROUP BY brand_name ORDER BY avg_screen_size asc LIMIT 1;


-- Group smartphones by the brands, Find brands which have highest no of nfc and IR blaster
SELECT brand_name, COUNT(*) as count from smartphones 
WHERE has_nfc='True' and has_ir_blaster='True' GROUP BY brand_name
ORDER BY count DESC limit 1;


-- Find all samsung 5g enable smartphones and find the avg price for NFC phone
SELECT has_nfc, AVG(price) FROM smartphones WHERE brand_name='samsung'
GROUP BY has_nfc;


SELECT model, price from smartphones ORDER BY price desc limit 1;



-- having works for group by

-- find avg price of phones of smartphones brands which have more than 20 phones
SELECT brand_name, count(*) as count, AVG(price) as avg_price from smartphones
GROUP BY brand_name having count>20;



/* Find the top 3 brands with the highest avg ram that have a refresh rate of at least 90 hz and fast charging available and 
don't consider brands which have less than 10 phones
*/


SELECT brand_name, avg(ram_capacity) as avg_ram from smartphones
where refresh_rate>90 and fast_charging_available = 1 GROUP BY brand_name
HAVING count(*)>10 ORDER BY avg_ram desc limit 3;


-- Find the avg price of all the phone brands with avg rating>70 and num_phones more than 10 among all 5g enabled phones
SELECT brand_name, AVG(price) as avg_price from smartphones where has_5g='True'
GROUP BY brand_name HAVING AVG(rating)>70 and count(*)>10;





