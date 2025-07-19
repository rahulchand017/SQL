use cleaning;

SELECT * FROM laptops;

ALTER TABLE laptops ADD COLUMN `index` INT;

SET @row = 0;
UPDATE laptops SET `index` = @row := @row + 1;

ALTER TABLE laptops MODIFY COLUMN `index` INT FIRST;



-- head, tail and sample
SELECT * FROM laptops ORDER BY `index` limit 5;

SELECT * FROM laptops ORDER BY `index` DESC limit 5;


SELECT * FROM laptops ORDER BY rand() LIMIT 5;


-- For numerical column
-- UNIVARIATE analysis


SELECT COUNT(Price) OVER(),
MIN(Price) OVER(),
MAX(Price) OVER(),
AVG(Price) OVER(),
STD(Price) OVER(),
PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptops
ORDER BY `index` LIMIT 1;
-- error can't solve

-- missing value
SELECT COUNT(Price)
FROM laptops
WHERE Price IS NULL;



-- OUTLIERS

-- Step 1: Rank the prices
WITH ranked AS (
    SELECT Price,
           ROW_NUMBER() OVER (ORDER BY Price) AS rn,
           COUNT(*) OVER () AS total_count
    FROM laptops
),
quartiles AS (
    SELECT 
        MAX(CASE WHEN rn = FLOOR(total_count * 0.25) THEN Price END) AS Q1,
        MAX(CASE WHEN rn = FLOOR(total_count * 0.75) THEN Price END) AS Q3
    FROM ranked
),
bounds AS (
    SELECT 
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
        Q3 + 1.5 * (Q3 - Q1) AS upper_bound
    FROM quartiles
)
-- Step 2: Join to apply bounds
SELECT l.*
FROM laptops l
JOIN bounds b
  ON l.Price < b.lower_bound OR l.Price > b.upper_bound;



-- Drawing histogram
SELECT t.buckets,REPEAT('*',COUNT(*)/5) FROM (SELECT price, 
CASE 
	WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
    WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
    WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
    WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
	ELSE '>100K'
END AS 'buckets'
FROM laptops) t
GROUP BY t.buckets;



-- vertical histogram






-- For categorical column
SELECT Company, COUNT(Company) as count FROM laptops
GROUP BY `Company` ORDER BY `count` DESC;


-- Bi-variate analysis

/*
 NUmerical-Numerical 
Scatter plot
Correlation (not in Mysql)
*/

SELECT cpu_speed,Price FROM laptops;

SELECT * FROM laptops;



-- Categorical- Categorical
-- Contingency table
SELECT Company,
SUM(CASE WHEN touch_screen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
SUM(CASE WHEN touch_screen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no'
FROM laptops
GROUP BY Company;


SELECT DISTINCT cpu_brand FROM laptops;

SELECT Company,
SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'intel',
SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'amd',
SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'samsung'
FROM laptops
GROUP BY Company;



-- Categorical Numerical Bivariate analysis
SELECT Company,MIN(price),
MAX(price),AVG(price),STD(price)
FROM laptops
GROUP BY Company;

-- Dealing with missing values
SELECT * FROM laptops
WHERE price IS NULL;


-- UPDATE laptops
-- SET price = NULL
-- WHERE `index` IN (7,869,1148,827,865,821,1056,1043,692,1114)

-- replace missing values with mean of price
UPDATE laptops
SET price = (
    SELECT avg_price
    FROM (SELECT AVG(price) AS avg_price FROM laptops) AS derived
)
WHERE price IS NULL;


-- replace missing values with mean price of corresponding company
UPDATE laptops l
JOIN (
    SELECT Company, AVG(price) AS avg_price
    FROM laptops
    WHERE price IS NOT NULL
    GROUP BY Company
) AS company_avg
ON l.Company = company_avg.Company
SET l.price = company_avg.avg_price
WHERE l.price IS NULL;

SELECT * FROM laptops WHERE price IS NULL;


-- Add PPI (Pixels Per Inch) Column
ALTER TABLE laptops ADD COLUMN ppi INTEGER;

UPDATE laptops
SET ppi = ROUND(SQRT(resolution_width*resolution_width + resolution_height*resolution_height)/Inches);


-- Add Categorical Screen Size
ALTER TABLE laptops ADD COLUMN screen_size VARCHAR(255) AFTER Inches;

UPDATE laptops
SET screen_size = 
CASE 
	WHEN Inches < 14.0 THEN 'small'
    WHEN Inches >= 14.0 AND Inches < 17.0 THEN 'medium'
	ELSE 'large'
END;


-- Group by screen size
SELECT screen_size, AVG(price) FROM laptops GROUP BY screen_size;


-- One Hot encoding for GPU Brands
SELECT gpu_brand,
CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'intel',
CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END AS 'amd',
CASE WHEN gpu_brand = 'nvidia' THEN 1 ELSE 0 END AS 'nvidia',
CASE WHEN gpu_brand = 'arm' THEN 1 ELSE 0 END AS 'arm'
FROM laptops;

