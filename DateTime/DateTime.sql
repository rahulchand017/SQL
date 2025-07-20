/*
TEMPORAL Data Types
- These are especially used to hold the time series data
1. DATE: YYYY-MM-DD
2. TIME: HH-MM-SS
3. DATETIME: YYYY-MM-DD HH-MM-SS
4. TIMESTAMP: YYYY-MM-DD HH-MM-SS
5. YEAR: YYYY or YY
*/

use campusx;

CREATE TABLE uber_rides (
    ride_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER,
    cab_id INTEGER,
    start_time DATETIME,
    end_time DATETIME
);

INSERT INTO uber_rides(user_id, cab_id, start_time, end_time) VALUES
-- (1,1, '2023-03-09 08:00:00', '2023-03-09 09:00:00'),
(2,3, '2023-03-10 10:00:00', '2023-03-10 10:30:00'),
(6,32, '2022-04-07 12:00:00', '2023-04-07 12:15:00'),
(9,40, '2024-11-29 04:16:00', '2023-11-29 04:51:00'),
(69,96, '2003-07-27 23:50:00', '2003-07-28 01:05:00'),
(9,11, '2001-09-11 08:00:00', '2001-09-11 09:00:00');

SELECT * FROM uber_rides;


/*
Date time function
1. Current_date()
2. Current_Time()
3. NOW()
*/
SELECT CURRENT_DATE();
SELECT CURRENT_TIME();

select NOW();


/*
EXTRACTION FUNCTIONS
1. DATE() and TIME()
2. YEAR()
3. DAY() or DAYOFMONTH()
4. DAYOFWEEK()
5. DAYOFYEAR()
6. MONTH() and MONTHNAME()
7. QUARTER()
8. WEEK() or WEEKOFYEAR()
9. HOUR() -> MINUTE() -> SECOND()
10. LAST_DAY()
*/

SELECT *, time(start_time), DATE(start_time), YEAR(start_time),
MONTH(start_time), MONTHNAME(start_time), day(last_day(start_time))
FROM uber_rides;


SELECT start_time, DATE_FORMAT(start_time, '%d %b %y' ) FROM uber_rides;

SELECT start_time, DATE_FORMAT(start_time, '%1:%i %p' ) FROM uber_rides;


-- Type conversion (Implicit)
SELECT '2023-03-11' > '2023-03-09';

SELECT '2023-03-11' > '9 May 2023';
-- Implicit type conversion failed, output is 0 should be 1

-- Explicit type conversion
-- STR_TO_DATE

SELECT STR_TO_DATE('20 June 2025', '%e %b %Y');
SELECT MONTHNAME(STR_TO_DATE('20 Jun 2025', '%e %b %Y'));


/*
DATETIME arithmetic
1. DATEDIFF()
2. TIMEDIFF()
3. DATE_ADD() and DATE_SUB()
4. ADDTIME() and SUBTIME()
*/

SELECT DATEDIFF(CURRENT_DATE(), '2022-08-20');

SELECT NOW(), DATE_ADD(NOW(), INTERVAL 10 YEAR);


/*
TIMESTAMP VS DATETIME


In MySQL, both DATETIME and TIMESTAMP are used to store date and
time values, but they differ in their range, storage format, and
behaviour.
Here are the main differences between DATETIME and TIMESTAMP:
1. Range: DATETIME supports a range of '1000-01-01 00:00:00' to
'9999-12-31 23:59:59', while TIMESTAMP supports a range of
'1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC.

2. Storage format: DATETIME uses 8 bytes to store the date and time
values, while TIMESTAMP uses 4 bytes.

3. Behaviour on insertion/update: DATETIME values are stored as-is,
without any conversion, while TIMESTAMP values are converted
from the current time zone to UTC when inserted, and converted
back to the current time zone when retrieved.

4. Precision: DATETIME can store up to microseconds (6 digits after
the decimal point), while TIMESTAMP can only store up to seconds.

5. Auto-update: TIMESTAMP columns can be set to update
automatically whenever the row is inserted or updated, using the
ON UPDATE CURRENT_TIMESTAMP clause.

In general, you should use DATETIME when you need to store date and
time values outside the range of TIMESTAMP, or when you need to
store values with greater precision than TIMESTAMP. You should use
TIMESTAMP when you need to store values that can be automatically
updated, or when you want to take advantage of its smaller storage
format.
T
*/

CREATE TABLE posts(
    post_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER,
    content text,
    creates_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON update CURRENT_TIMESTAMP

);

INSERT INTO posts(user_id, content) VALUES (1,'hello world');

UPDATE posts
SET content = 'No more hello world'
WHERE post_id = 1;

SELECT * FROM posts;