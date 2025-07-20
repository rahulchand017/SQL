/*
Views:- A view is a virtual table that does not store amy data but presents a customized view of one or more tables in a database.
So basically it is a virtual table not a physical table.

Any change in underline table will reflect in the view.

Views are of 2 type:
1. Simple view :- Created from 1 single table.
2. Complex view:- Created from multiple tables with the help of joins, subquery etc.
*/

use flights;
CREATE View indigo as 
SELECT * FROM flights
WHERE airline = 'Indigo';

SELECT * FROM indigo;


USE zomato;

SELECT * FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id 
JOIN restaurants t3
ON t1.r_id = t3.r_id;


CREATE VIEW joined_order AS
SELECT order_id, amount, r_name, name, date, delivery_time,
delivery_rating, restaurant_rating
FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id 
JOIN restaurants t3
ON t1.r_id = t3.r_id;



SELECT r_name, MONTH(date), SUM(amount)
FROM joined_order
GROUP BY r_name, MONTH(date);


-- Read only vs Updatable Views
-- A view can be UPDATABLE if only it is not made from any clauses, joins, where
UPDATE indigo
SET destination = 'Delhi'
WHERE `Destination` = 'New Delhi';

SELECT * FROM flights;

-- Materialized view (not in MySql)



/*
Functions
1. Built in Function
2. User defined function
- User Def fun
CREATE FUNCTION function_name(
parameter_1 DataType,
parameter_2 DataType,
parameter_n DataType
)
RETURNS Return_Datatype
[NOT] DETERMINISTIC
BEGIN
     Function Body
     Return Return_value
END $$
*/
CREATE FUNCTION hello_world() 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN 'hello_world';
END $$


SELECT hello_world();


SELECT hello_world() FROM person;


SELECT UPPER(gender) FROM dt_demo;


-- Non-Parameterize() and Parameterize(a,b) function



DELIMITER $$

CREATE FUNCTION calculate_age(dob DATE)
RETURNS INTEGER
DETERMINISTIC
NO SQL
BEGIN
    DECLARE age INTEGER;
    SET age = ROUND(DATEDIFF(CURDATE(), dob) / 365);
    RETURN age;
END $$

DELIMITER ;

SELECT calculate_age(`Date_of_Journey`) FROM flights;



CREATE FUNCTION proper_name(name VARCHAR(255), gender VARCHAR(255), married VARCHAR(255))
RETURNS VARCHAR(255)
NO SQL
BEGIN
     DECLARE title VARCHAR(255);
     IF gender = 'M' THEN
        SET title = CONCAT('Mr', ' ', name);
    ELSE
        IF married = 'Y' THEN
           SET title = CONCAT('Mrs', ' ', name);
        ELSE
           SET title = CONCAT('Ms', ' ', name);
        END IF;
    END IF;
RETURN title;
END;

DELIMITER $$
CREATE FUNCTION format_date(doj DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
NO SQL
BEGIN
    RETURN DATE_FORMAT(doj, '%D %b %y');
END $$
DELIMITER ;
-- DETERMINISTIC output is always same

SELECT format_date(Date_of_Journey) FROM flights;


-- NON deterministic function
