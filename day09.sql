-- FILE ./ex00/day09_ex00.sql

CREATE TABLE IF NOT EXISTS person_audit
    (
        id bigint NOT NULL
            PRIMARY KEY,
        created timestamp WITH TIME ZONE DEFAULT NOW() NOT NULL,
        type_event char(1) DEFAULT 'I' NOT NULL
            CONSTRAINT ch_type_event
                CHECK (type_event IN ('I', 'U', 'D')),
        row_id bigint NOT NULL,
        name varchar,
        age integer,
        gender varchar,
        address varchar
    );

CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit() RETURNS TRIGGER AS
$person_audit$
BEGIN
    INSERT INTO person_audit
        SELECT (SELECT COALESCE(MAX(id) + 1, 1)  FROM person_audit), NOW(), 'I', NEW.*;
    RETURN NULL;
END;
$person_audit$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_insert_audit
    AFTER INSERT ON person
        FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_insert_audit();

-- Check

INSERT INTO person(id, name, age, gender, address) VALUES (10, 'Damir', 22, 'male', 'Irkutsk');
SELECT * FROM person WHERE id = 10;
SELECT * FROM person_audit WHERE row_id = 10;
/*
CREATE TABLE
CREATE FUNCTION
CREATE TRIGGER
INSERT 0 1
 id | name  | age | gender | address 
----+-------+-----+--------+---------
 10 | Damir |  22 | male   | Irkutsk
(1 row)

 id |            created            | type_event | row_id | name  | age | gender | address 
----+-------------------------------+------------+--------+-------+-----+--------+---------
  1 | 2022-12-03 16:34:14.221886+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  2 | 2022-12-03 16:34:18.8068+07   | U          |     10 | Damir |  22 | male   | Irkutsk
  3 | 2022-12-03 16:34:21.000024+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
  4 | 2022-12-03 16:34:23.080022+07 | D          |     10 | Damir |  22 | male   | Irkutsk
  5 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  6 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
(6 rows)
*/

-- FILE ./ex01/day09_ex01.sql

CREATE OR REPLACE FUNCTION fnc_trg_person_update_audit() RETURNS TRIGGER AS
$person_audit$
BEGIN
    INSERT INTO person_audit
        SELECT (SELECT COALESCE(MAX(id) + 1, 1)  FROM person_audit), NOW(), 'U', OLD.*;
    RETURN NULL;
END;
$person_audit$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_update_audit
    AFTER UPDATE ON person
        FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_update_audit();

-- Check

UPDATE person SET name = 'Bulat' WHERE id = 10;
SELECT * FROM person WHERE id = 10;
SELECT * FROM person_audit WHERE row_id = 10;

UPDATE person SET name = 'Damir' WHERE id = 10;
SELECT * FROM person WHERE id = 10;
SELECT * FROM person_audit WHERE row_id = 10;
/*
CREATE FUNCTION
CREATE TRIGGER
UPDATE 1
 id | name  | age | gender | address 
----+-------+-----+--------+---------
 10 | Bulat |  22 | male   | Irkutsk
(1 row)

 id |            created            | type_event | row_id | name  | age | gender | address 
----+-------------------------------+------------+--------+-------+-----+--------+---------
  1 | 2022-12-03 16:34:14.221886+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  2 | 2022-12-03 16:34:18.8068+07   | U          |     10 | Damir |  22 | male   | Irkutsk
  3 | 2022-12-03 16:34:21.000024+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
  4 | 2022-12-03 16:34:23.080022+07 | D          |     10 | Damir |  22 | male   | Irkutsk
  5 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  6 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  7 | 2022-12-06 18:40:06.250742+07 | U          |     10 | Damir |  22 | male   | Irkutsk
  8 | 2022-12-06 18:40:06.250742+07 | U          |     10 | Damir |  22 | male   | Irkutsk
(8 rows)

UPDATE 1
 id | name  | age | gender | address 
----+-------+-----+--------+---------
 10 | Damir |  22 | male   | Irkutsk
(1 row)

 id |            created            | type_event | row_id | name  | age | gender | address 
----+-------------------------------+------------+--------+-------+-----+--------+---------
  1 | 2022-12-03 16:34:14.221886+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  2 | 2022-12-03 16:34:18.8068+07   | U          |     10 | Damir |  22 | male   | Irkutsk
  3 | 2022-12-03 16:34:21.000024+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
  4 | 2022-12-03 16:34:23.080022+07 | D          |     10 | Damir |  22 | male   | Irkutsk
  5 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  6 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  7 | 2022-12-06 18:40:06.250742+07 | U          |     10 | Damir |  22 | male   | Irkutsk
  8 | 2022-12-06 18:40:06.250742+07 | U          |     10 | Damir |  22 | male   | Irkutsk
  9 | 2022-12-06 18:40:06.252643+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
 10 | 2022-12-06 18:40:06.252643+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
(10 rows)
*/

-- FILE ./ex02/day09_ex02.sql

CREATE OR REPLACE FUNCTION fnc_trg_person_delete_audit() RETURNS TRIGGER AS
$person_audit$
BEGIN
    INSERT INTO person_audit
        SELECT (SELECT COALESCE(MAX(id) + 1, 1)  FROM person_audit), NOW(), 'D', OLD.*;
    RETURN NULL;
END;
$person_audit$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_delete_audit
    AFTER DELETE ON person
        FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_delete_audit();

-- Check

DELETE FROM person WHERE id = 10;
SELECT * FROM person WHERE id = 10;
SELECT * FROM person_audit WHERE row_id = 10;
/*
CREATE FUNCTION
CREATE TRIGGER
DELETE 1
 id | name | age | gender | address 
----+------+-----+--------+---------
(0 rows)

 id |            created            | type_event | row_id | name  | age | gender | address 
----+-------------------------------+------------+--------+-------+-----+--------+---------
  1 | 2022-12-03 16:34:14.221886+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  2 | 2022-12-03 16:34:18.8068+07   | U          |     10 | Damir |  22 | male   | Irkutsk
  3 | 2022-12-03 16:34:21.000024+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
  4 | 2022-12-03 16:34:23.080022+07 | D          |     10 | Damir |  22 | male   | Irkutsk
  5 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  6 | 2022-12-06 18:40:06.234541+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  7 | 2022-12-06 18:40:06.250742+07 | U          |     10 | Damir |  22 | male   | Irkutsk
  8 | 2022-12-06 18:40:06.250742+07 | U          |     10 | Damir |  22 | male   | Irkutsk
  9 | 2022-12-06 18:40:06.252643+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
 10 | 2022-12-06 18:40:06.252643+07 | U          |     10 | Bulat |  22 | male   | Irkutsk
 11 | 2022-12-06 18:40:06.26638+07  | D          |     10 | Damir |  22 | male   | Irkutsk
 12 | 2022-12-06 18:40:06.26638+07  | D          |     10 | Damir |  22 | male   | Irkutsk
(12 rows)
*/

-- FILE ./ex03/day09_ex03.sql

CREATE OR REPLACE FUNCTION fnc_trg_person_audit() RETURNS TRIGGER AS
$person_audit$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO person_audit
        SELECT (SELECT COALESCE(MAX(id) + 1, 1)  FROM person_audit), NOW(), 'I', NEW.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO person_audit
        SELECT (SELECT COALESCE(MAX(id) + 1, 1)  FROM person_audit), NOW(), 'U', OLD.*;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO person_audit
        SELECT (SELECT COALESCE(MAX(id) + 1, 1)  FROM person_audit), NOW(), 'D', OLD.*;
    END IF;
    RETURN NULL;
END;
$person_audit$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_audit
    AFTER INSERT OR UPDATE OR DELETE ON person
        FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_audit();

DROP TRIGGER IF EXISTS trg_person_insert_audit ON person;
DROP TRIGGER IF EXISTS trg_person_update_audit ON person;
DROP TRIGGER IF EXISTS trg_person_delete_audit ON person;
DROP FUNCTION IF EXISTS fnc_trg_person_insert_audit();
DROP FUNCTION IF EXISTS fnc_trg_person_update_audit();
DROP FUNCTION IF EXISTS fnc_trg_person_delete_audit();
TRUNCATE person_audit;

-- Check

SELECT * FROM person_audit;

INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
DELETE FROM person WHERE id = 10;

SELECT * FROM person_audit;
/*
CREATE FUNCTION
CREATE TRIGGER
DROP TRIGGER
DROP TRIGGER
DROP TRIGGER
DROP FUNCTION
DROP FUNCTION
DROP FUNCTION
TRUNCATE TABLE
 id | created | type_event | row_id | name | age | gender | address 
----+---------+------------+--------+------+-----+--------+---------
(0 rows)

INSERT 0 1
UPDATE 1
UPDATE 1
DELETE 1
 id |            created            | type_event | row_id | name  | age | gender | address 
----+-------------------------------+------------+--------+-------+-----+--------+---------
  1 | 2022-12-06 18:40:06.284084+07 | I          |     10 | Damir |  22 | male   | Irkutsk
  2 | 2022-12-06 18:40:06.285023+07 | U          |     10 | Damir |  22 | male   | Irkutsk
  3 | 2022-12-06 18:40:06.28545+07  | U          |     10 | Bulat |  22 | male   | Irkutsk
  4 | 2022-12-06 18:40:06.285671+07 | D          |     10 | Damir |  22 | male   | Irkutsk
(4 rows)
*/

-- FILE ./ex04/day09_ex04.sql

CREATE OR REPLACE FUNCTION fnc_persons_female()
    RETURNS TABLE
            (
                id      bigint,
                name    varchar,
                age     integer,
                gender  varchar,
                address varchar
            )
AS
$$
SELECT *
FROM person
WHERE gender = 'female';
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION fnc_persons_male()
    RETURNS TABLE
            (
                id      bigint,
                name    varchar,
                age     integer,
                gender  varchar,
                address varchar
            )
AS
$$
SELECT *
FROM person
WHERE gender = 'male';
$$ LANGUAGE sql;

-- Check

SELECT *
FROM fnc_persons_female();

SELECT *
FROM fnc_persons_male();
/*
CREATE FUNCTION
CREATE FUNCTION
 id |  name  | age | gender |     address      
----+--------+-----+--------+------------------
  1 | Anna   |  16 | female | Moscow
  3 | Kate   |  33 | female | Kazan
  5 | Elvira |  45 | female | Kazan
  6 | Irina  |  21 | female | Saint-Petersburg
  8 | Nataly |  30 | female | Novosibirsk
(5 rows)

 id |  name   | age | gender |     address      
----+---------+-----+--------+------------------
  2 | Andrey  |  21 | male   | Moscow
  4 | Denis   |  13 | male   | Kazan
  7 | Peter   |  24 | male   | Saint-Petersburg
  9 | Dmitriy |  18 | male   | Samara
(4 rows)
*/

-- FILE ./ex05/day09_ex05.sql

DROP FUNCTION fnc_persons_female();
DROP FUNCTION fnc_persons_male();

CREATE OR REPLACE FUNCTION fnc_persons(pgender varchar DEFAULT 'female')
    RETURNS TABLE
            (
                id      bigint,
                name    varchar,
                age     integer,
                gender  varchar,
                address varchar
            )
AS
$$
SELECT *
FROM person
WHERE gender = pgender;
$$ LANGUAGE sql;

SELECT *
FROM fnc_persons(pgender := 'male');

SELECT *
FROM fnc_persons();
/*
DROP FUNCTION
DROP FUNCTION
CREATE FUNCTION
 id |  name   | age | gender |     address      
----+---------+-----+--------+------------------
  2 | Andrey  |  21 | male   | Moscow
  4 | Denis   |  13 | male   | Kazan
  7 | Peter   |  24 | male   | Saint-Petersburg
  9 | Dmitriy |  18 | male   | Samara
(4 rows)

 id |  name  | age | gender |     address      
----+--------+-----+--------+------------------
  1 | Anna   |  16 | female | Moscow
  3 | Kate   |  33 | female | Kazan
  5 | Elvira |  45 | female | Kazan
  6 | Irina  |  21 | female | Saint-Petersburg
  8 | Nataly |  30 | female | Novosibirsk
(5 rows)
*/

-- FILE ./ex06/day09_ex06.sql

DROP FUNCTION fnc_person_visits_and_eats_on_date(character varying, numeric, date);

CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date(
    pperson varchar DEFAULT 'Dmitriy',
    pprice numeric DEFAULT 500,
    pdate date DEFAULT '2022-01-08'
)
    RETURNS TABLE
            (
                name varchar
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT pz.name
        FROM (SELECT pv.pizzeria_id
              FROM person_visits pv
                       JOIN person p ON pv.person_id = p.id
              WHERE pv.visit_date = pdate
                AND p.name = pperson
              INTERSECT
              SELECT m.pizzeria_id
              FROM menu m
              WHERE m.price < pprice) AS pvp
                 JOIN pizzeria pz ON pz.id = pvp.pizzeria_id;
END;
$$ LANGUAGE plpgsql;

-- Check

SELECT *
FROM fnc_person_visits_and_eats_on_date(pprice := 800);

SELECT *
FROM fnc_person_visits_and_eats_on_date(pperson := 'Anna', pprice := 1300, pdate := '2022-01-01');
/*
CREATE FUNCTION
    name    
------------
 Papa Johns
 DoDo Pizza
(2 rows)

   name    
-----------
 Pizza Hut
(1 row)
*/

-- FILE ./ex07/day09_ex07.sql

-- DROP FUNCTION func_minimum(numeric[]);

CREATE OR REPLACE FUNCTION func_minimum(VARIADIC arr numeric[]) RETURNS numeric AS
$$
DECLARE
    idx int := 0;
    min numeric;
    x   numeric;
BEGIN
    FOREACH x IN ARRAY $1
        LOOP
            IF idx = 0 OR x < min THEN
                min := x;
            END IF;
            idx := idx + 1;
        END LOOP;
    RETURN min;
END;
$$ LANGUAGE plpgsql;


SELECT func_minimum(VARIADIC arr => ARRAY [10.0, -1.0, 5.0, 4.4]);
/*
CREATE FUNCTION
 func_minimum 
--------------
         -1.0
(1 row)
*/

-- FILE ./ex08/day09_ex08.sql

CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop int DEFAULT 10)
    RETURNS SETOF integer
AS $$
BEGIN
RETURN QUERY
    WITH RECURSIVE cte
        AS (
            SELECT 0 AS n1, 1 AS n2
        UNION ALL
            SELECT GREATEST(n1, n2), n1 + n2 as n2 from cte
            WHERE n2 < pstop
       )
    SELECT n1 FROM cte;
END;
$$ LANGUAGE plpgsql;

-- Check

SELECT *
FROM fnc_fibonacci();
DROP FUNCTION fnc_fibonacci(int);

--

CREATE OR REPLACE FUNCTION fnc_fibonacci_recursive(pstop int DEFAULT 10)
    RETURNS SETOF integer
AS $$
BEGIN
    CASE pstop
        WHEN 0, 1 THEN
            RETURN QUERY
                SELECT pstop;
        ELSE
            RETURN QUERY
                SELECT fnc_fibonacci_recursive(pstop - 2) +
                       fnc_fibonacci_recursive(pstop - 1);
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Check

SELECT *
FROM fnc_fibonacci_recursive();
-- DROP FUNCTION fnc_fibonacci_recursive(int);


DELETE FROM person_order WHERE id = 23 OR id=24;
/*
CREATE FUNCTION
 fnc_fibonacci 
---------------
             0
             1
             1
             2
             3
             5
             8
(7 rows)

DROP FUNCTION
CREATE FUNCTION
 fnc_fibonacci_recursive 
-------------------------
                      55
(1 row)

DELETE 0
*/