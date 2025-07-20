/*
INT
TINYINT
SMALLINT
BIGINT

Unsigned 0 - +ve
Signed -ve +ve
*/
use campusx;

CREATE TABLE dt_demo(
    user_id SMALLINT,
    course_id SMALLINT UNSIGNED
);


SELECT * FROM dt_demo;

INSERT INTO dt_demo VALUES(200,200);

/*
DECIMAL : DECIMAL(x,y)  8 bytes
x total number of digit
y digits after
*/

ALTER Table dt_demo add COLUMN price DECIMAL(5,2);

UPDATE dt_demo
SET price = 349.25;

-- Float and DOUBLE
-- 4 bytes

ALTER Table dt_demo ADD COLUMN weight double;
ALTER Table dt_demo ADD COLUMN height double;



UPDATE dt_demo
SET height = 172.3456, weight = 60.456;

SELECT * FROM dt_demo;

INSERT INTO dt_demo (height, weight) VALUES (172.345678945545, 60.4567);


/* STRING
1. Char
2. VARCHAR
3. MEDIUMTEXT
4. LONGTEXT
5. TEXT
*/

-- ENUM
-- SET
-- part of string

ALTER Table dt_demo ADD COLUMN gender ENUM('male', 'female', 'others');
-- there can't be any other gender except these 3

UPDATE dt_demo
SET gender = 'male';

-- SET
-- can add multiple value at the same time except this everything is same as ENUM

ALTER Table dt_demo ADD COLUMN hobby SET('sports', 'gaming');

INSERT INTO dt_demo (hobby) VALUES
('sports','gaming'),('sports'),('gaming'),('dancing');

SELECT * FROM dt_demo;


-- BLOB binary large object
-- Part of text data type
-- TinyBLOB
-- BLOB
-- MEDIUMBLOB
-- LONGBLOG

ALTER Table dt_demo ADD COLUMN gt MEDIUMBLOB;

INSERT INTO dt_demo (gt) VALUES (LOAD_FILE("C:/Users/rahul/OneDrive/Pictures/1295780.jpg"));
SELECT * from dt_demo;



/*
SPATIAL DATATYPE
1. GEOMETRY
*/

ALTER Table dt_demo ADD COLUMN latloc GEOMETRY;
SELECT * FROM dt_demo;

INSERT INTO dt_demo (latloc) VALUES (Point(67.456, 89.01234));
SELECT ST_AsText(latloc), ST_X(latloc) from dt_demo;


-- json
-- key value pair

ALTER Table dt_demo ADD COLUMN description JSON;

INSERT INTO dt_demo (description) VALUES ('{"os":"android", "type":"smartphone"}');

SELECT JSON_EXTRACT(description, '$.type') FROM dt_demo;
-- extracted the value of type key


