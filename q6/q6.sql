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

-- 6. List the names of students who have taken all courses offered by department v8 (deptId).

SELECT name FROM Student,
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))) as alias
WHERE id = alias.studId;

-- OPTIMIZATION Step 1
-- Create indexes for unique columns

CREATE INDEX index_stud_id ON student (id);

CREATE INDEX index_c_crscourse ON course (crsCode);

CREATE INDEX index_c_deptid ON course (deptId);

CREATE INDEX index_trans_studid ON transcript (studId);

CREATE INDEX index_trans_crscode ON transcript (crsCode);

CREATE INDEX index_teaching_profId ON teaching (profId);

CREATE INDEX index_teaching_crs ON teaching (crsCode);

-- OPTIMIZATION Step 2
-- CREATE CTE

WITH course_cte AS
(SELECT crsCode
FROM course
WHERE deptId = @v8)
SELECT name 
FROM Student AS s
INNER JOIN transcript AS t ON s.id = t.studId
INNER JOIN course_cte AS ccte ON t.crsCode = ccte.crsCode
WHERE t.crsCode IN (ccte.crsCode);
