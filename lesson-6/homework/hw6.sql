--puzle_1 
-- (a,b) ~ (b,a)
SELECT DISTINCT
  CASE WHEN col1 <= col2 THEN col1 ELSE col2 END AS col1,
  CASE WHEN col1 <= col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;


--puzzle_2
SELECT *
FROM TestMultipleZero
WHERE A <> 0 OR B <> 0 OR C <> 0 OR D <> 0;


--Puzzle 3 — Rows with odd IDs
SELECT *
FROM section1
WHERE id % 2 = 1;   -- odd

--Puzzle 4 — Person with the smallest id
-- TOP 1
SELECT TOP (1) *
FROM section1
ORDER BY id ASC;

-- or with MIN()
SELECT s.*
FROM section1 s
JOIN (SELECT MIN(id) AS min_id FROM section1) m
  ON s.id = m.min_id;

--Puzzle 5 — Person with the highest id
-- TOP 1
SELECT TOP (1) *
FROM section1
ORDER BY id DESC;

-- or with MAX()
SELECT s.*
FROM section1 s
JOIN (SELECT MAX(id) AS max_id FROM section1) m
  ON s.id = m.max_id;

--Puzzle 6 — Names starting with b (case-insensitive by default)
SELECT *
FROM section1
WHERE name LIKE 'B%';          -- default collations: case-insensitive

-- If you must force case-insensitive regardless of DB collation:
-- WHERE LOWER(name) LIKE 'b%';

--Puzzle 7 — Code contains a literal underscore _

--(remember _ is a single-character wildcard in LIKE)

Way A: Bracket escape
SELECT *
FROM ProductCodes
WHERE Code LIKE '%[_]%';
