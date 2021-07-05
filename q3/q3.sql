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

-- 3. List the names of students who have taken course v4 (crsCode).
SELECT 
    name
FROM
    Student
WHERE
    id IN (SELECT 
            studId
        FROM
            Transcript
        WHERE
            crsCode = @v4);
            
-- OPTIMIZATION Step 1
-- Analyze query using EXPLAIN and EXPLAIN ANALYZE

EXPLAIN ANALYZE
SELECT 
    name
FROM
    Student
WHERE
    id IN (SELECT 
            studId
        FROM
            Transcript
        WHERE
            crsCode = @v4);

-- OPTIMIZATION Step 2
-- Try using INNER JOIN

EXPLAIN ANALYZE
SELECT name
FROM student s
INNER JOIN transcript t
ON s.id = t.studId
WHERE crsCode = @v4;

-- OPTIMIZATION Step 3
-- Try creating indexes on student.id column and transcript.studId column

CREATE INDEX index_id
ON student (id);

CREATE INDEX index_studId
ON transcript (studId);


-- OPTIMIZATION Step 4
-- Analyze new query speed with indexes using EXPLAIN and EXPLAIN ANALYZE


SELECT name
FROM student s
INNER JOIN transcript t
ON s.id = t.studId
WHERE crsCode = @v4;


-- OPTIMIZATION Step 5
-- Create index on crsCode column

CREATE INDEX index_crsCode
ON transcript (crsCode);

-- OPTIMIZATION Step 6
-- Analyze using EXPLAIN and EXPLAIN ANALYZE

SELECT name
FROM student s
INNER JOIN transcript t
ON s.id = t.studId
WHERE crsCode = @v4;