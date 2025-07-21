/*
Stored Procedure
A stored procedure is a named block of SQL statements and procedural logic that is stored in a database and can be executed 
by a user ar application.

stored procedure can be used to encapsulate business logic and application logic, such as data visualization, data processing, and 
database updates. 
Used to separate application logic from thr presentation layer and simplify the application code.
*/

USE zomato;
CREATE PROCEDURE hello_world()
BEGIN
     SELECT 'hello_world';
END;


CALL hello_world();
CREATE Procedure add_user(IN input_name varchar(255), IN input_email VARCHAR(255), OUT message VARCHAR(255))
--  OUT message VARCHAR(255) is used so that we would be able to know if the changes occur in our Procedure
BEGIN
     -- Check if input_email exists in user table
     DECLARE user_count INTEGER;
     SELECT COUNT(*) INTO user_count FROM users where email = input_email;
     -- insert the new user
     IF user_count = 0 THEN
        INSERT INTO users(name, email) VALUES (input_name, input_email);
        SET message = 'User inserted';
    ELSE 
        SET message = "Email already exist";
    END IF;
END;

SET @message = '';
CALL add_user('Lawda pur','jhatu123@corn.com', @message);

SELECT @message;

SELECT * FROM users;

/*
Benefits of STORED PROCEDURE
1. Improve performance
2. Enhanced security
3. Encapsulation of business logic
4. Consistency
5. Reduce network traffic
*/

-- make stored procedure which would display all the order of the user through his name 
DELIMITER $$
CREATE PROCEDURE user_order(IN input_email VARCHAR(255))
BEGIN
    DECLARE id INT;
    -- Get the user_id into variable `id`
    SELECT user_id INTO id FROM users WHERE email = input_email;
    -- Select orders using the fetched user_id
    SELECT * FROM orders WHERE user_id = id;
END
DELIMITER ;

CALL user_order('khushboo@gmail.com');


CREATE PROCEDURE place_order(IN input_user_id INTEGER, IN input_r_id INTEGER, IN input_f_ids VARCHAR(255), OUT total_amount INTEGER)
BEGIN
     -- insert into orders table
     DECLARE new_order_id INTEGER;
     DECLARE f_id1 INTEGER;
     DECLARE f_id2 INTEGER;

     SET f_id1 = SUBSTRING_INDEX(input_f_ids,',', 1);
     SET f_id2 = SUBSTRING_INDEX(input_f_ids,',', -1);



     SELECT MAX(order_id) + 1 INTO new_order_id FROM orders;

     SELECT SUM(price) INTO total_amount FROM menu
     WHERE r_id = input_r_id AND f_id IN (f_id1, f_id2);

     INSERT INTO orders (order_id, user_id, r_id, amount, date) VALUES
     (new_order_id, input_user_id, input_r_id, total_amount, date(NOW()));

     INSERT INTO order_details(order_id, f_id) VALUES
     (new_order_id, f_id1), (new_order_id, f_id2);
     -- insert into order_details table 

END;

SET @total=0;
CALL place_order(3,3,'6,7',@total);

SELECT @total;

