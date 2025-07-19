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
-- This gets the last word in the ScreenResolution string (assuming resolution info is last):
-- For '1920x1080' → '1920x1080'
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x',-1)
FROM laptops;


ALTER TABLE laptops
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

SELECT * FROM laptops;

UPDATE laptops
SET
resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(`ScreenResolution`, ' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(`ScreenResolution`, ' ',-1),'x',-1);

ALTER TABLE laptops
ADD COLUMN touch_screen INTEGER AFTER resolution_height;

SELECT ScreenResolution LIKE '%Touch%' FROM laptops;

UPDATE laptops
SET touch_screen = `ScreenResolution` LIKE '%Touch%';

ALTER TABLE laptops
DROP COLUMN ScreenResolution;

SELECT cpu_name,
SUBSTRING_INDEX(TRIM(cpu_name),' ',2)
FROM laptops;
-- TRIM works same as STRIP

UPDATE laptops
SET cpu_name = SUBSTRING_INDEX(TRIM(cpu_name),' ',2);

SELECT DISTINCT cpu_name FROM laptops;

SELECT Memory FROM laptops;

ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

SELECT Memory,
CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END AS 'memory_type'
FROM laptops;


SELECT Memory,
CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END AS 'memory_type'
FROM laptops;


UPDATE laptops
SET memory_type = CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END;


SELECT Memory,
REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END
FROM laptops;


UPDATE laptops
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;



UPDATE laptops
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;


-- primary store has value 1 and 2
SELECT 
primary_storage,
CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage,
CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END
FROM laptops;

UPDATE laptops
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

SELECT * FROM laptops;

ALTER TABLE laptops DROP COLUMN Memory;

ALTER TABLE laptops DROP COLUMN gpu_name;

SELECT * FROM laptops;
