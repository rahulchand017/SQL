/*
WILDCARDS
LIKE operator is used to match a string value against a pattern.
Uses % represent zero, one, more characters
_ represent a single character.
*/

use imdb;
SELECT title FROM movies
WHERE title LIKE '____';
-- looking for 4 character with the help of four _



SELECT title FROM movies
where title like '%nan';






/*
TEXT
1. CHAR :- Fixed size of string
2. VARCHAR :- Provide the limit of the size
3. TEXT :- Is used to store large amount of data, up to 65535 characters.
4. MEDIUMTEXT :- Store large amount of text data than TEXT.
5. LONGTEXT :- Store the largest amount of data
*/




--STRING Functions


-- upper/lower

SELECT * from movies;
SELECT title, UPPER(title), LOWER(title) FROM movies;


-- concat
SELECT CONCAT(title, ' ', languages, ' ', production_company) FROM movies;

SELECT CONCAT_WS('@',title, languages, production_company) FROM movies;


-- substr
SELECT title, SUBSTR(title,1,5) FROM movies;
-- everything in sql starts with index 1

SELECT title, SUBSTR(title,-5,1) FROM movies;


-- REPLACE
SELECT title, REPLACE(title, 'man','women') FROM movies;


-- REVERSE
SELECT title FROM movies
WHERE title = reverse(title);



-- length :- return the length of the string in bytes
-- char :- return the length of the string characters.

SELECT title, LENGTH(title), CHAR_LENGTH(title) FROM movies;


-- INSERT
SELECT INSERT('hello world', 7,5,'India');
-- 7 represent the word from where to start replacing and 5 represent the no of char replace.


-- left/right
SELECT title, LEFT(title,3) , RIGHT(title,3) FROM movies;

-- REPEAT
SELECT REPEAT(title,3) FROM movies;


-- trim
SELECT TRIM("     rahul   ");
SELECT TRIM(BOTH'.' FROM '........rahul....');
SELECT RTRIM("   rahul      ");
SELECT LTRIM("   rahul      ");



-- substring_index (split)
SELECT SUBSTRING_INDEX('www.campusx.in','.',1);
SELECT SUBSTRING_INDEX('www.campusx.in','.',-2);



-- strcmp
-- Strcmp function return an integer that indicates the relationship

SELECT STRCMP("Delhi",'Mumbai');
SELECT STRCMP('Mumbai',"Delhi");


-- locate
SELECT LOCATE('w', 'hello world');


--PAD
SELECT LPAD('9719013120', 13, '+91' );
-- 13 means that teh final value will have 13 character after adding +91 in the previous no.

SELECT RPAD('9719013120', 13, '+91' );

