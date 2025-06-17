use course;


-- Find top 5 samsung phones with biggest screen size
SELECT model, screen_size FROM smartphones WHERE
brand_name='samsung' ORDER BY screen_size DESC LIMIT 5;


-- sort all the phone in descending order of number of total cameras
SELECT model, num_front_cameras + num_rear_cameras as total_cameras
FROM smartphones ORDER BY total_cameras desc;



-- Sort data on the basis of ppi in descending order
SELECT model, 
ROUND(SQRT(resolution_width * resolution_width + resolution_height * resolution_height)/ screen_size)
as ppi FROM smartphones ORDER BY ppi DESC;



-- Sort the phones with 2nd largest battery
-- limit x,y (x= offset leave all those rows, y = no of rows from that offset)
SELECT model, battery_capacity from smartphones ORDER BY 
battery_capacity desc limit 1,1;

SELECT * FROM smartphones;

 -- Find the name and rating of the worst rated apple phone
 SELECT model, rating from smartphones where brand_name='apple' 
 ORDER BY rating ASC limit 1;


SELECT * FROM smartphones ORDER BY brand_name ASC, price asc;






































