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

select * FROM smartphones;







































































































