-- FILE ./ex00/day02_ex00.sql

SELECT pz.name, pz.rating
  FROM pizzeria pz
           LEFT JOIN person_visits pv
           ON pz.id = pv.pizzeria_id
 WHERE pv.pizzeria_id IS NULL;

/*
 name | rating 
------+--------
(0 rows)
*/

-- FILE ./ex01/day02_ex01.sql

SELECT gs::date AS missing_date
  FROM GENERATE_SERIES('2022-01-01', '2022-01-10', '1 day'::interval) gs
           LEFT JOIN (SELECT * FROM person_visits WHERE person_id = 1 OR person_id = 2) AS pv
           ON pv.visit_date = gs
 WHERE visit_date IS NULL
 ORDER BY missing_date ASC;
/*
 missing_date 
--------------
 2022-01-03
 2022-01-04
 2022-01-05
 2022-01-06
 2022-01-07
 2022-01-08
 2022-01-09
 2022-01-10
(8 rows)
*/

-- FILE ./ex02/day02_ex02.sql

SELECT COALESCE(p.name, '-') AS person_name, pv.visit_date, COALESCE(pz.name, '-') AS pizzeria_name
  FROM (SELECT * FROM person_visits WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03') AS pv
           FULL JOIN person p
           ON pv.person_id = p.id
           FULL JOIN pizzeria pz
           ON pv.pizzeria_id = pz.id
 ORDER BY person_name ASC, pv.visit_date ASC;
/*
 person_name | visit_date | pizzeria_name 
-------------+------------+---------------
 -           |            | DinoPizza
 -           |            | DoDo Pizza
 Andrey      | 2022-01-01 | Dominos
 Andrey      | 2022-01-02 | Pizza Hut
 Anna        | 2022-01-01 | Pizza Hut
 Denis       |            | -
 Dmitriy     |            | -
 Elvira      |            | -
 Irina       | 2022-01-01 | Papa Johns
 Kate        | 2022-01-03 | Best Pizza
 Nataly      |            | -
 Peter       | 2022-01-03 | Pizza Hut
(12 rows)
*/

-- FILE ./ex03/day02_ex03.sql

  WITH md AS (SELECT gs::date AS missing_date FROM GENERATE_SERIES('2022-01-01', '2022-01-10', '1 day'::interval) gs),
       pv12 AS (SELECT * FROM person_visits WHERE person_id = 1 OR person_id = 2)

SELECT missing_date
  FROM md
           LEFT JOIN pv12
           ON pv12.visit_date = md.missing_date
 WHERE pv12.visit_date IS NULL
 ORDER BY md.missing_date ASC;
/*
 missing_date 
--------------
 2022-01-03
 2022-01-04
 2022-01-05
 2022-01-06
 2022-01-07
 2022-01-08
 2022-01-09
 2022-01-10
(8 rows)
*/

-- FILE ./ex04/day02_ex04.sql

SELECT m.pizza_name, pz.name AS pizzeria_name, m.price
  FROM menu m
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id
 WHERE m.pizza_name = 'mushroom pizza'
    OR m.pizza_name = 'pepperoni pizza'
 ORDER BY m.pizza_name, pz.name;
/*
   pizza_name    | pizzeria_name | price 
-----------------+---------------+-------
 mushroom pizza  | Dominos       |  1100
 mushroom pizza  | Papa Johns    |   950
 pepperoni pizza | Best Pizza    |   800
 pepperoni pizza | DinoPizza     |   800
 pepperoni pizza | Papa Johns    |  1000
 pepperoni pizza | Pizza Hut     |  1200
(6 rows)
*/

-- FILE ./ex05/day02_ex05.sql

SELECT p.name
  FROM person p
 WHERE p.gender = 'female'
   AND p.age > 25
 ORDER BY p.name ASC;
/*
  name  
--------
 Elvira
 Kate
 Nataly
(3 rows)
*/

-- FILE ./ex06/day02_ex06.sql

SELECT m.pizza_name, pz.name AS pizzeria_name
  FROM person_order po
           JOIN person p
           ON p.id = po.person_id
           JOIN menu m
           ON m.id = po.menu_id
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id
 WHERE p.name = 'Denis'
    OR p.name = 'Anna'
 ORDER BY m.pizza_name ASC, pz.name ASC;

/*
   pizza_name    | pizzeria_name 
-----------------+---------------
 cheese pizza    | Best Pizza
 cheese pizza    | Pizza Hut
 pepperoni pizza | Best Pizza
 pepperoni pizza | DinoPizza
 pepperoni pizza | Pizza Hut
 sausage pizza   | DinoPizza
 sicilian pizza  | Dominos
 supreme pizza   | Best Pizza
(8 rows)
*/

-- FILE ./ex07/day02_ex07.sql

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
JOIN menu m ON pz.id = m.pizzeria_id
WHERE m.price < 800;
/*
    name    
------------
 DoDo Pizza
 Papa Johns
(2 rows)
*/

-- FILE ./ex08/day02_ex08.sql

SELECT p.name
  FROM person_order po
           JOIN person p
           ON po.person_id = p.id
           JOIN menu m
           ON po.menu_id = m.id
 WHERE p.gender = 'male'
   AND (p.address = 'Moscow' OR p.address = 'Samara')
   AND (m.pizza_name = 'pepperoni pizza' OR m.pizza_name = 'mushroom pizza')
 ORDER BY p.name DESC;
/*
  name   
---------
 Dmitriy
 Andrey
(2 rows)
*/

-- FILE ./ex09/day02_ex09.sql

     WITH md AS (SELECT *
                   FROM person_order po
                            JOIN menu m
                            ON po.menu_id = m.id
                            JOIN person p
                            ON po.person_id = p.id
                  WHERE p.gender = 'female')
   SELECT md1.name
     FROM md md1
    WHERE md1.pizza_name = 'pepperoni pizza'
INTERSECT
   SELECT md2.name
     FROM md md2
    WHERE md2.pizza_name = 'cheese pizza';
/*
  name  
--------
 Anna
 Nataly
(2 rows)
*/

-- FILE ./ex10/day02_ex10.sql

SELECT p1.name, p2.name, p1.address
  FROM person p1
           CROSS JOIN person p2
 WHERE p1.name < p2.name
   AND p1.address = p2.address
 ORDER BY p1.name, p2.name, p1.address;

-- SELECT person.name AS person_name1, n.name AS person_name2, person.address AS common_address
--   FROM person,
--        (SELECT id, name, address FROM person p) AS n
--  WHERE person.address = n.address
--    AND person.id > n.id
--  ORDER BY person_name1, person_name2, common_address;
/*
  name  |  name  |     address      
--------+--------+------------------
 Andrey | Anna   | Moscow
 Denis  | Elvira | Kazan
 Denis  | Kate   | Kazan
 Elvira | Kate   | Kazan
 Irina  | Peter  | Saint-Petersburg
(5 rows)
*/