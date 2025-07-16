CREATE DATABASE cleaning;
USE cleaning;

SELECT * FROM laptops;

CREATE TABLE laptops_backup like laptops;
INSERT INTO laptops_backup
SELECT * FROM laptops;

-- check memory occupy for reference
SELECT `DATA_LENGTH`/1024 FROM information_schema.TABLES
where `TABLE_SCHEMA` = 'cleaning'
AND `TABLE_NAME` = 'laptops';


-- Drop non important column
SELECT * FROM laptops;

ALTER Table laptops DROP COLUMN `Unnamed: 0`;
SELECT * FROM laptops;


-- Remove all rows with null values
DELETE FROM laptops 
WHERE `index` IN (SELECT `index` FROM laptops
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL);


-- drop duplicates
SELECT name, age, gender, MIN(id)
FROM zomato.duplicates
GROUP BY name, age, gender
HAVING COUNT(*)>1;


DELETE FROM zomato.duplicates
where id NOT IN (SELECT MIN(id)
FROM zomato.duplicates
GROUP BY name, gender, age);


-- clean RAM
SELECT DISTINCT Company FROM laptops;
SELECT DISTINCT TypeName FROM laptops;

ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,1);

--Remove GB from RAM

UPDATE laptops
SET Ram = REPLACE(Ram, 'GB', '');
SELECT * FROM laptops;

ALTER TABLE laptops MODIFY COLUMN Ram INTEGER;


-- Update weight removing kg
UPDATE laptops
SET `Weight` = REPLACE(`Weight`,'kg','');


UPDATE laptops
SET price = ROUND(price);

ALTER TABLE laptops
MODIFY COLUMN price INTEGER;



SELECT DISTINCT OpSys FROM laptops;
-- mac
-- windows
-- linux
-- no os
-- Android chrome(others)

SELECT OpSys,
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM laptops;


UPDATE laptops
SET OpSys = 
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END;


SELECT * FROM laptops;

ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

SELECT * FROM laptops;


UPDATE laptops 
SET gpu_brand = SUBSTRING_INDEX(Gpu, ' ', 1);

UPDATE laptops
SET gpu_name = TRIM(REPLACE(Gpu, gpu_brand, ''));

ALTER Table laptops DROP COLUMN Gpu;


ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;


SELECT * FROM laptops;

UPDATE laptops
SET 
  cpu_brand = SUBSTRING_INDEX(Cpu, ' ', 1),
  cpu_speed = CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10,2)),
  cpu_name = TRIM(
    REPLACE(
      REPLACE(Cpu, SUBSTRING_INDEX(Cpu, ' ', 1), ''),
      SUBSTRING_INDEX(Cpu, ' ', -1),
      ''
    )
  );


SELECT * FROM laptops;

ALTER Table laptops
DROP COLUMN Cpu;

SELECT ScreenResolution, 
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',-1)
FROM laptops;


