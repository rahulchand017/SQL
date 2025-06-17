CREATE DATABASE course;
USE course;

CREATE TABLE users(
    user_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

INSERT INTO course.users(user_id, name, email, password)
VALUES (NULL, 'rahul', 'rahul@fku.com', '1234');


INSERT INTO course.users(name, email, password)
VALUES ('rupesh', 'rupesh@example.com', '123456');


-- Multiple insertion

INSERT INTO users (name, email, password)
VALUES 
    ('anita', 'anita@example.com', 'anita@123'),
    ('john', 'john.doe@example.com', 'j@hnD03'),
    ('ravi', 'ravi@example.com', 'ravipass');



SELECT * FROM users;


SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C://Users//rahul//OneDrive//SQL//SQL basics//DML//smartphones_cleaned_v6.csv'
INTO TABLE smartphones
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * FROM course.smartphones;

-- SELECT all columns
SELECT * FROM course.smartphones;


SELECT model, price, rating FROM smartphones;

SELECT model, battery_capacity, os FROM smartphones;


SELECT model as mo, price, rating as pasand FROM smartphones;


/* CREATING new column */

SELECT model, 
SQRT(resolution_width * resolution_width + resolution_height * resolution_height)/ screen_size 
as ppi FROM smartphones;



/* Creating a default value */
SELECT model, 'smartphone' as ADDtype from smartphones;



/* DISTINCT */
SELECT DISTINCT brand_name as brands FROM smartphones;

SELECT DISTINCT processor_brand as Processor FROM smartphones;



/*UNIQUE combination */

SELECT DISTINCT brand_name, processor_brand from smartphones;


-- FILTERING rows based on where clause


/*FIND all samsung brands */

SELECT * FROM smartphones battery_capacity
WHERE brand_name = 'samsung';


SELECT * FROM smartphones
WHERE price>50000;


SELECT  * FROM smartphones
WHERE price <21000 AND rating>80;

SELECT * FROM smartphones WHERE brand_name = 'samsung' AND ram_capacity > 8


SELECT brand_name FROM smartphones WHERE price>100000;




/*IN and NOT IN*/
SELECT * FROM smartphones WHERE processor_brand
IN ('snapdragon', 'exynos','bionic')







-- Update

UPDATE smartphones SET processor_brand = 'dimensity'
WHERE processor_brand = 'mediatek';

SELECT * FROM smartphones WHERE processor_brand='mediatek'


-- Delete
DELETE FROM smartphones WHERE price>200000;





/* Types of functions in SQL
1. Builtin 
a) Scalar
b) Aggregate (avg)


2. User defined
*/


/*
Aggregate function
- MAX/MIN
- AVG
- COUNT
- SUM
- STD
- VAR
*/
SELECT max(price) FROM smartphones;

SELECt max(price) FROM smartphones WHERE brand_name ='samsung';


-- Find the total oneplus phones
SELECT COUNT(brand_name) FROM smartphones WHERE brand_name='oneplus'; 


SELECT COUNT(DISTINCT(processor_brand)) FROM smartphones; 




/* Scalar Function
- ABS (absolute)
- ROUND
- CEIL/FLOOR

*/

SELECT  price - 100000 AS 'temp' FROM smartphones;

-- ABS
SELECT  ABS(price - 100000) AS temp FROM smartphones;






















