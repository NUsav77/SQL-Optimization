USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 2. List the names of students with id in the range of v2 (id) to v3 (inclusive).

SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;

-- OPTIMIZATION STEP 1
-- Create index on id column

CREATE INDEX id_index
ON student (id);

-- OPTIMIZATION STEP 2
-- Create index on both id and name column

CREATE INDEX id_index
ON student (id, name);

SELECT name 
FROM Student 
WHERE id BETWEEN @v2 AND @v3;