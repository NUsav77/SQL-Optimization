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

-- 4. List the names of students who have taken a course taught by professor v5 (name).

SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			WHERE Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

-- OPTIMIZATION Step 1
-- Create indexes for all primary keys

CREATE INDEX index_student_id
ON student (id);

CREATE INDEX index_profId
ON teaching (profId);

CREATE INDEX index_prof_id
ON professor (id);

CREATE INDEX index_crsCode
ON course (crsCode);

-- OPTIMIZATION Step 2
-- Create temporary tables

CREATE TEMPORARY TABLE prof_v5 AS
	SELECT name, id
    FROM professor
    WHERE name = @v5;
    
CREATE TEMPORARY TABLE teaching_v5 AS
	SELECT t.crsCode, t.profId, p.name
    FROM teaching AS t
    INNER JOIN prof_v5 AS p
    ON p.id = t.profId
    WHERE p.id = t.profId;
    
CREATE TEMPORARY TABLE trans_v5 AS
	SELECT t.studId, t.crsCode
    FROM transcript AS t
    INNER JOIN teaching_v5 AS te
    ON te.crsCode = t.crs_code
    WHERE t.crsCode = te.crsCode;
    
SELECT * FROM trans_v5;

-- OPTIMIZATION Step 3
-- INNER JOIN trans_v5 TEMP TABLE with new query

SELECT s.name
FROM student AS s
INNER JOIN trans_v5 AS t
ON t.studId = s.id
WHERE s.id = t.studId;