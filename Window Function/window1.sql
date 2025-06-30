/*
Window function in SQL are a type of analytical function that perform calculations across a set of rows that are related to 
the current row, calling a 'window'.
A window function calculates a value for each row in the result set based on a subset of the rows that are defined by a 
window specification.
*/

-- SELECT *, AVG(marks) OVER(PARTITION BY branch) FROM campusx.marks;

use campusx;
CREATE TABLE marks (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    branch VARCHAR(50),
    marks INT
);
INSERT INTO marks (student_id, name, branch, marks) VALUES
(1, 'Aarav Sharma', 'Computer Science', 89),
(2, 'Diya Verma', 'Electronics', 78),
(3, 'Rohan Mehta', 'Mechanical', 65),
(4, 'Sneha Patel', 'Civil', 72),
(5, 'Yash Singh', 'Computer Science', 95),
(6, 'Tanya Rao', 'Electrical', 81),
(7, 'Aniket Das', 'Electronics', 67),
(8, 'Meera Iyer', 'Computer Science', 88),
(9, 'Kunal Roy', 'Mechanical', 74),
(10, 'Ritika Nair', 'Civil', 59),
(11, 'Vivek Malhotra', 'Computer Science', 91),
(12, 'Pooja Joshi', 'Electronics', 83),
(13, 'Aditya Kaul', 'Electrical', 76),
(14, 'Ishita Bansal', 'Mechanical', 69),
(15, 'Harshit Saxena', 'Civil', 82);

-- Find all students who have marks higher than the avg marks of their respective branch.
SELECT * FROM students WHERE marks > (SELECT avg(marks) FROM students);

SELECT * FROM (SELECT *, AVG(marks) OVER(PARTITION BY branch) as branch_avg 
FROM marks) t
WHERE t.marks> t.branch_avg;


/*
1. RANK
2. DENSE RANK
3. ROW NUMBER
*/

-- RANK gave two similar rank and skip the next
SELECT *, RANK() OVER(ORDER BY marks DESC) FROM marks;
SELECT *, RANK() OVER(PARTITION BY branch ORDER BY marks DESC) FROM marks;


-- DENSE RANK
-- It give the same rank to person have same marks, but don't skip the next one.
SELECT *, DENSE_RANK() OVER(ORDER BY marks desc) from marks;


-- ROW NUMBER
SELECT *, ROW_NUMBER() OVER(PARTITION BY branch) from marks;




use zomato;
SELECT MONTHNAME(date), user_id, SUM(amount)
FROM orders
GROUP BY MONTHNAME(date), user_id
ORDER BY MONTH(date); 


SELECT * FROM (SELECT 
                        MONTH(date) AS 'month_no',
                        MONTHNAME(date) AS 'month',
                        user_id,
                        SUM(amount) AS 'total',
                        RANK() OVER(PARTITION BY MONTHNAME(date) ORDER BY SUM(amount) DESC) as 'month_rank'
                        FROM orders
                        GROUP BY MONTH(date), MONTHNAME(date), user_id
                        ORDER BY MONTH(date)) t
                        WHERE t.month_rank < 3;




/*
1. FIRST VALUE
2. LAST VALUE
3. NTH_VALUE
*/


-- Find the student name who has scored the highest marks
SELECT *, FIRST_VALUE(name) OVER(ORDER BY marks desc)
FROM marks;


SELECT *, LAST_VALUE(name) OVER(ORDER BY marks desc)
FROM marks;

/*
Due to `Frames` we will not be getting out expected output of lowest marks named student.
Frame in window function is the subset of rows within the partition that determines the scope of the window function calculation.

*/

/*
FRAMES are described by ROWS and BETWEEN
1. ROWS BETWEEN UNBOUNDED AND CURRENT ROWS
2. ROES BETWEEN PRECEDING AND 1 FOLLOWING
3. ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
4. ROWS BETWEEN 3 PRECEDING AND 2 FOLLOWING
*/

SELECT *, LAST_VALUE(name) OVER(ORDER BY marks desc
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
FROM marks;



SELECT *, NTH_VALUE(name,2) OVER(PARTITION BY branch ORDER BY marks desc
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
FROM marks;



SELECT name, branch, marks FROM (SELECT *, FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks desc) 'topper_name',
        FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks desc) 'topper_marks'
        from marks) t
    WHERE t.name = t.topper_name AND t.marks = t.topper_marks;



-- Other way to define WINDOW function

SELECT name, branch, marks
FROM (
    SELECT *,
           LAST_VALUE(name) OVER w AS topper_name,
           LAST_VALUE(marks) OVER w AS topper_marks
    FROM students
    WINDOW w AS (
        PARTITION BY branch 
        ORDER BY marks DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
) t
WHERE t.name = t.topper_name AND t.marks = t.topper_marks;


-- LEAD/ LAG
SELECT *, LAG(marks) OVER(ORDER BY student_id) FROM marks;
SELECT *, LEAD(marks) OVER(ORDER BY student_id) FROM marks;

use zomato;
-- Find month on month revenue growth of zomato
SELECT * FROM orders;

SELECT 
  month_name,
  month_no,
  total_amount,
  total_amount - LAG(total_amount) OVER (ORDER BY month_no) AS month_diff
FROM (
    SELECT 
        MONTHNAME(date) AS month_name,
        MONTH(date) AS month_no,
        SUM(amount) AS total_amount
    FROM orders
    GROUP BY MONTHNAME(date), MONTH(date)
) AS monthly_summary
ORDER BY month_no;
