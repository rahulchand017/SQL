create DATABASE campusx;
DROP DATABASE campusx;

create DATABASE IF NOT EXISTS campusx;
USE campusx;

-- CREATE

CREATE TABLE users(
    user_id INTEGER,
    name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
)

-- TRUNCATE
TRUNCATE table users;

-- DROP
DROP TABLE IF EXISTS users;


-- CONSTRAINS
/*
NOT NULL
UNIQUE
PRIMARY KEY
AUTO INCREMENT
CHECK
DEFAULT
FOREIGN KEY

*/


-- REFERENTIAL ACTIONS
/*
RESTRICT
CASCADE 
SET NULL
SET DEFAULT 
*/
CREATE TABLE users(
    user_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    password VARCHAR(255)
)

DROP TABLE users;
--UNIQUE
CREATE TABLE users(
    user_id INTEGER NOT NULL,
    name VARCHAR(225) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(225) NOT NULL
)

DROP TABLE users;


-- This constraint will that there should be a unique value for name+email
CREATE TABLE user(
    user_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,

    CONSTRAINT user_email_unique UNIQUE(name,email)

)

DROP TABLE user;


-- PRIMARY KEY
CREATE TABLE users(
    user_id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
)


DROP TABLE users;

CREATE TABLE users(
    user_id INTEGER NOT NULL ,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,

    CONSTRAINT user_email_unique UNIQUE(name,email),
    CONSTRAINT user_pk PRIMARY KEY(user_id)

)

DROP TABLE users;

-- AUTO INCREMENT

CREATE TABLE users(
    user_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
)


-- CHECK
USE campusx; 
CREATE TABLE students(
    stu_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    stu_name VARCHAR(255) NOT NULL,
    age INTEGER CHECK (age > 6 AND age<25) 

    /*
    CONSTRAINT students_age_check CHECK(age > 6 AND age<25) 

    */
)


-- DEFAULT
use campusx;
CREATE TABLE ticket(
    ticket_id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    travel_date DATETIME DEFAULT CURRENT_TIMESTAMP
)

-- FOREIGN KEY

use campusx;

CREATE TABLE customers (
    cid INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    cid INTEGER NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_fk FOREIGN KEY (cid) REFERENCES customers(cid)
);


/*
Referential Action
- What will happen to delete and update when two table are connected vis FOREIGN KEY.
1. RESTRICT:- Doesn't allow any updates or delete
2. CASCADE:- Change in one will appear in second too.
3. SET NULL
4. SET DEFAULT
*/

use campusx;
DROP TABLE orders;

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    cid INTEGER NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_fk FOREIGN KEY (cid) REFERENCES customers(cid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);





-- ALTER TABLE
/*
Use to modify the structure of an existing table. Some of the thing that can be done using the ALTER TABLE statement include
1. Add columns
2. Delete columns
3. Modify columns
*/

-- ADD COLUMN in alter table
ALTER TABLE customers ADD COLUMN password VARCHAR(255) NOT NULL;


ALTER TABLE customers ADD COLUMN surname VARCHAR(255) NOT NULL AFTER name;


ALTER TABLE customers
ADD COLUMN pan_number VARCHAR(255) AFTER surname,
ADD COLUMN joining_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- DELETE COLUMN in alter table
ALTER TABLE customers
DROP COLUMN password,
DROP COLUMN joining_date;


-- MODIFY in alter table
ALTER TABLE customers
MODIFY COLUMN surname INTEGER ;



-- Doing changes in CONSTRAINT (add and delete only)

ALTER TABLE customers ADD CONSTRAINT customers_age_check CHECK(age>)
ALTER TABLE customers DROP CONSTRAINT customers_age_check CHECK(age>)


