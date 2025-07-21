/*
Transactions
A database transaction is a sequence of operations that are performed as a single logic unit of work in a database management 
system(DBMS).
A database may consist of one or more database operations such as insert, updates, or delete, which are treated on a single 
atomic operation by the DBMS.

1. Commit:- Permanent changes, cannot be rollback.
2. Rollback 
3. Savepoint
*/

-- AUTOcommit
-- It is a feature of DBMS that automatically commits each individual database transaction and is committed immediately after it is executed.

use zomato;
-- Create the 'person' table
CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    dob DATE,
    gender CHAR(1),
    married CHAR(1),
    balance INT
);

-- Insert the values
INSERT INTO person (id, name, dob, gender, married, balance) VALUES
(1, 'nitish', '1990-10-24', 'M', 'Y', 45000),
(2, 'ankita', '1993-02-11', 'F', 'Y', 35000),
(3, 'rahul', '1995-06-19', 'M', 'N', 10000),
(4, 'amrita', '2000-10-10', 'F', 'N', 5000),
(5, 'amit', '2003-11-11', 'M', 'N', 40000);
ALTER TABLE person MODIFY id INT NOT NULL AUTO_INCREMENT;


-- auto commit
UPDATE person SET balance = 50000 WHERE id =1;


SELECT * FROM person;

SET autocommit = 0;

INSERT INTO person (name) VALUES ('rishabh');

-- start transaction without autocommit
START TRANSACTION;
UPDATE person set balance = 40000 WHERE id =1;
UPDATE person set balance = 25000 WHERE id =5;
COMMIT;

SELECT * FROM person;


-- all or none 
UPDATE person set balance = 30000 WHERE id =1;
UPDATE person set balance = 25000 WHERE id =5;
ROLLBACK;



-- ROLLBACK
START TRANSACTION;
SAVEPOINT A;
UPDATE person set balance = 30000 WHERE id =1;
SAVEPOINT B;
UPDATE person set balance = 25000 WHERE id =5;
ROLLBACK TO B;




-- ROLLBACK and commit together




/*
                  ACID
These are already executed within the database.                 
1. Atomicity:- Executed full or non

2. Consistency:- Take from one valid state to other valid state. Total money same honi chahiye sab kuch krne ke baad.

3. Isolation:- Concurrent transaction do not interfere with each other, transaction execute as if it were the only transaction 
executed against the database, even if multiple transaction are executing at the same time. (Schedule krke koi chij hoti hai to jo serial run krti hai)

4. Durability:- Availability at any point of time, when user need.
*/