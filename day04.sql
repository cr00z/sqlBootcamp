-- FILE ./ex00/day04_ex00.sql

CREATE OR REPLACE VIEW v_persons_female
AS
SELECT *
  FROM person p
 WHERE p.gender = 'female';

CREATE OR REPLACE VIEW v_persons_male
AS
SELECT *
  FROM person p
 WHERE p.gender = 'male';

-- SELECT * FROM v_persons_female;
-- SELECT * FROM v_persons_male;

/*
CREATE VIEW
CREATE VIEW
*/

-- FILE ./ex01/day04_ex01.sql

SELECT name
  FROM (SELECT name FROM v_persons_female UNION SELECT name FROM v_persons_male) AS p
 ORDER BY name;
/*
  name   
---------
 Andrey
 Anna
 Denis
 Dmitriy
 Elvira
 Irina
 Kate
 Nataly
 Peter
(9 rows)
*/

-- FILE ./ex02/day04_ex02.sql

CREATE OR REPLACE VIEW v_generated_dates
AS
SELECT DATE_TRUNC('day', dt)::date AS generated_date
  FROM GENERATE_SERIES('2022-01-01'::date, '2022-01-31'::date, '1 day'::interval) AS dt
 ORDER BY dt;

-- SELECT * FROM v_generated_dates;
-- DROP VIEW v_generated_dates;
/*
CREATE VIEW
*/

-- FILE ./ex03/day04_ex03.sql

SELECT v.generated_date AS missing_date
  FROM v_generated_dates AS v
           LEFT JOIN person_visits pv
           ON v.generated_date = pv.visit_date
 WHERE pv.visit_date IS NULL
 ORDER BY missing_date;

/*
 missing_date 
--------------
 2022-01-11
 2022-01-12
 2022-01-13
 2022-01-14
 2022-01-15
 2022-01-16
 2022-01-17
 2022-01-18
 2022-01-19
 2022-01-20
 2022-01-21
 2022-01-22
 2022-01-23
 2022-01-24
 2022-01-25
 2022-01-26
 2022-01-27
 2022-01-28
 2022-01-29
 2022-01-30
 2022-01-31
(21 rows)
*/

-- FILE ./ex04/day04_ex04.sql

CREATE OR REPLACE VIEW pv2
AS
SELECT person_id
  FROM person_visits
 WHERE visit_date = '2022-01-02';

CREATE OR REPLACE VIEW pv6
AS
SELECT person_id
  FROM person_visits
 WHERE visit_date = '2022-01-06';

CREATE OR REPLACE VIEW v_symmetric_union
AS
SELECT u.person_id
  FROM (
    (SELECT * FROM pv2 EXCEPT SELECT * FROM pv6)
    UNION
    (SELECT * FROM pv6 EXCEPT SELECT * FROM pv2)
  ) AS u
 ORDER BY u.person_id;

--SELECT * FROM v_symmetric_union;

/*
CREATE VIEW
CREATE VIEW
CREATE VIEW
*/

-- FILE ./ex05/day04_ex05.sql

CREATE OR REPLACE VIEW v_price_with_discount
AS
SELECT p.name, m.pizza_name, m.price, m.price * 0.9 AS discount_price
  FROM person_order po
           JOIN person p
           ON po.person_id = p.id
           JOIN menu m
           ON po.menu_id = m.id
 ORDER BY p.name, m.pizza_name;

SELECT * FROM v_price_with_discount;
/*
CREATE VIEW
  name   |   pizza_name    | price | discount_price 
---------+-----------------+-------+----------------
 Andrey  | cheese pizza    |   800 |          720.0
 Andrey  | mushroom pizza  |  1100 |          990.0
 Anna    | cheese pizza    |   900 |          810.0
 Anna    | pepperoni pizza |  1200 |         1080.0
 Denis   | cheese pizza    |   700 |          630.0
 Denis   | pepperoni pizza |   800 |          720.0
 Denis   | pepperoni pizza |   800 |          720.0
 Denis   | sausage pizza   |  1000 |          900.0
 Denis   | sicilian pizza  |   900 |          810.0
 Denis   | sicilian pizza  |   900 |          810.0
 Denis   | supreme pizza   |   850 |          765.0
 Dmitriy | pepperoni pizza |   800 |          720.0
 Dmitriy | supreme pizza   |   850 |          765.0
 Elvira  | pepperoni pizza |   800 |          720.0
 Elvira  | sausage pizza   |  1000 |          900.0
 Irina   | mushroom pizza  |   950 |          855.0
 Irina   | sicilian pizza  |   900 |          810.0
 Irina   | sicilian pizza  |   900 |          810.0
 Kate    | cheese pizza    |   700 |          630.0
 Nataly  | cheese pizza    |   800 |          720.0
 Nataly  | pepperoni pizza |  1000 |          900.0
 Peter   | mushroom pizza  |  1100 |          990.0
 Peter   | sausage pizza   |  1200 |         1080.0
 Peter   | supreme pizza   |  1200 |         1080.0
(24 rows)
*/

-- FILE ./ex06/day04_ex06.sql

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_dmitriy_visits_and_eats
AS
   SELECT pz.name
     FROM person_visits pv
              JOIN person p
              ON pv.person_id = p.id
              JOIN pizzeria pz
              ON pv.pizzeria_id = pz.id
    WHERE pv.visit_date = '2022-01-08'
      AND p.name = 'Dmitriy'
INTERSECT
   SELECT pz.name
     FROM pizzeria pz
              JOIN menu m
              ON pz.id = m.pizzeria_id
    WHERE m.price < 800;

-- SELECT * FROM mv_dmitriy_visits_and_eats;
/*
CREATE MATERIALIZED VIEW
*/

-- FILE ./ex07/day04_ex07.sql

   INSERT INTO person_visits
   VALUES ((SELECT MAX(id) + 1 FROM person_visits),
           (SELECT p.id FROM person p WHERE p.name = 'Dmitriy'),
           (SELECT m.pizzeria_id
              FROM menu m
                       JOIN pizzeria pz
                       ON m.pizzeria_id = pz.id
             WHERE m.price < 800
               AND pz.name != 'Papa Johns'
             LIMIT 1),
           '2022-01-08');

   SELECT pz.name
     FROM person_visits pv
              JOIN person p
              ON pv.person_id = p.id
              JOIN pizzeria pz
              ON pv.pizzeria_id = pz.id
    WHERE pv.visit_date = '2022-01-08'
      AND p.name = 'Dmitriy'
INTERSECT
   SELECT pz.name
     FROM pizzeria pz
              JOIN menu m
              ON pz.id = m.pizzeria_id
    WHERE m.price < 800;

SELECT * FROM mv_dmitriy_visits_and_eats;

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

SELECT * FROM mv_dmitriy_visits_and_eats;
/*
    name    
------------
 DoDo Pizza
 Papa Johns
(2 rows)

 pizzeria_name 
---------------
 Papa Johns
 DoDo Pizza
(2 rows)

REFRESH MATERIALIZED VIEW
 pizzeria_name 
---------------
 Papa Johns
 DoDo Pizza
(2 rows)
*/

-- FILE ./ex08/day04_ex08.sql

DROP VIEW IF EXISTS v_persons_female;
DROP VIEW IF EXISTS v_persons_male;
DROP VIEW IF EXISTS v_generated_dates;
DROP VIEW IF EXISTS v_symmetric_union;
DROP VIEW IF EXISTS pv2;
DROP VIEW IF EXISTS pv6;
DROP VIEW IF EXISTS v_price_with_discount;

DROP MATERIALIZED VIEW IF EXISTS mv_dmitriy_visits_and_eats;

/*
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP VIEW
DROP MATERIALIZED VIEW
*/
