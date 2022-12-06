-- FILE ./ex00/day03_ex00.sql

SELECT m.pizza_name, m.price, pz.name AS pizzeria_name, pv.visit_date
  FROM person_visits pv
           JOIN menu m
           ON pv.pizzeria_id = m.pizzeria_id
           JOIN person p
           ON pv.person_id = p.id
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id
 WHERE (p.name = 'Kate')
   AND (m.price BETWEEN 800 AND 1000)
 ORDER BY m.pizza_name, m.price, pz.name;
/*
   pizza_name    | price | pizzeria_name | visit_date 
-----------------+-------+---------------+------------
 cheese pizza    |   950 | DinoPizza     | 2022-01-04
 pepperoni pizza |   800 | Best Pizza    | 2022-01-03
 pepperoni pizza |   800 | DinoPizza     | 2022-01-04
 sausage pizza   |  1000 | DinoPizza     | 2022-01-04
 supreme pizza   |   850 | Best Pizza    | 2022-01-03
(5 rows)
*/

-- FILE ./ex01/day03_ex01.sql

SELECT m.id AS menu_id
  FROM menu m
           LEFT JOIN person_order po
           ON m.id = po.menu_id
 WHERE po.menu_id IS NULL
 ORDER BY po.menu_id ASC;
/*
 menu_id 
---------
       5
      10
      11
      12
      15
(5 rows)
*/

-- FILE ./ex02/day03_ex02.sql

  WITH pom AS (SELECT *
                 FROM menu m
                          LEFT JOIN person_order po
                          ON m.id = po.menu_id
                WHERE po.menu_id IS NULL)

SELECT pom.pizza_name, pom.price, pz.name AS pizzeria_name
  FROM pom
           JOIN pizzeria pz
           ON pom.pizzeria_id = pz.id
 ORDER BY pom.pizza_name, pom.price;
/*
  pizza_name   | price | pizzeria_name 
---------------+-------+---------------
 cheese pizza  |   700 | Papa Johns
 cheese pizza  |   780 | DoDo Pizza
 cheese pizza  |   950 | DinoPizza
 sausage pizza |   950 | Papa Johns
 supreme pizza |   850 | DoDo Pizza
(5 rows)
*/

-- FILE ./ex03/day03_ex03.sql

  WITH pvp AS (SELECT pz.name, p.gender
                 FROM person_visits pv
                          JOIN person p
                          ON pv.person_id = p.id
                          JOIN pizzeria pz
                          ON pv.pizzeria_id = pz.id),
       pvpm AS (SELECT name FROM pvp WHERE gender = 'male'),
       pvpf AS (SELECT name FROM pvp WHERE gender = 'female')

SELECT name AS pizzeria_name
  FROM (
      (SELECT * FROM pvpm EXCEPT ALL SELECT * FROM pvpf)
        UNION ALL
      (SELECT * FROM pvpf EXCEPT ALL SELECT * FROM pvpm)
  ) AS ua
 ORDER BY pizzeria_name;
/*
 pizzeria_name 
---------------
 Best Pizza
 DoDo Pizza
 Dominos
 Papa Johns
(4 rows)
*/

-- FILE ./ex04/day03_ex04.sql

  WITH pop AS (SELECT pz.name, p.gender
                 FROM person_order po
                          JOIN person p
                          ON po.person_id = p.id
                          JOIN menu m
                          ON po.menu_id = m.id
                          JOIN pizzeria pz
                          ON m.pizzeria_id = pz.id),
       popm AS (SELECT name FROM pop WHERE gender = 'male'),
       popf AS (SELECT name FROM pop WHERE gender = 'female')

SELECT name AS pizzeria_name
  FROM (
      (SELECT * FROM popm EXCEPT SELECT * FROM popf)
        UNION
      (SELECT * FROM popf EXCEPT SELECT * FROM popm)
  ) AS u
 ORDER BY pizzeria_name;
/*
 pizzeria_name 
---------------
 Papa Johns
(1 row)
*/

-- FILE ./ex05/day03_ex05.sql

SELECT pz.name AS pizzeria_name
  FROM person_visits pv
           JOIN person p
           ON pv.person_id = p.id
           JOIN pizzeria pz
           ON pv.pizzeria_id = pz.id
 WHERE p.name = 'Andrey'

EXCEPT

SELECT pz.name
  FROM person_order po
           JOIN person p
           ON po.person_id = p.id
           JOIN menu m
           ON m.id = po.menu_id
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id
 WHERE p.name = 'Andrey';
/*
 pizzeria_name 
---------------
 Pizza Hut
(1 row)
*/

-- FILE ./ex06/day03_ex06.sql

  WITH pzm AS (SELECT m.pizza_name, pz.name, m.price
                 FROM pizzeria pz
                          JOIN menu m
                          ON pz.id = m.pizzeria_id)
SELECT p1.pizza_name, p1.name, p2.name, p1.price
  FROM pzm AS p1
           JOIN pzm AS p2
           ON p1.pizza_name = p2.pizza_name AND p1.price = p2.price AND p1.name < p2.name
 ORDER BY p1.pizza_name;

-- с дубликатами AND p1.name != p2.name
/*
   pizza_name    |    name    |    name    | price 
-----------------+------------+------------+-------
 cheese pizza    | Best Pizza | Papa Johns |   700
 pepperoni pizza | Best Pizza | DinoPizza  |   800
 supreme pizza   | Best Pizza | DoDo Pizza |   850
(3 rows)
*/

-- FILE ./ex07/day03_ex07.sql

INSERT INTO menu
VALUES (19, 2, 'greek pizza', 800);

-- SELECT * FROM menu;
/*
INSERT 0 1
*/
-- FILE ./ex08/day03_ex08.sql

INSERT INTO menu
VALUES ((SELECT MAX(m.id) + 1 FROM menu m),
        (SELECT pz.id FROM pizzeria pz WHERE pz.name = 'Dominos'),
        'sicilian pizza',
        900);

-- SELECT * FROM menu;
-- DELETE FROM menu WHERE id=21;

-- FILE ./ex09/day03_ex09.sql

INSERT INTO person_visits
VALUES ((SELECT MAX(pv.id) + 1 FROM person_visits pv),
        (SELECT p.id FROM person p WHERE p.name = 'Denis'),
        (SELECT pz.id FROM pizzeria pz WHERE pz.name = 'Dominos'),
        '2022-02-24'),
       ((SELECT MAX(pv.id) + 2 FROM person_visits pv),
        (SELECT p.id FROM person p WHERE p.name = 'Irina'),
        (SELECT pz.id FROM pizzeria pz WHERE pz.name = 'Dominos'),
        '2022-02-24');

-- SELECT * FROM person_visits;

-- FILE ./ex10/day03_ex10.sql

INSERT INTO person_order
VALUES ((SELECT MAX(po.id) + 1 FROM person_order po),
        (SELECT p.id FROM person p WHERE p.name = 'Denis'),
        20,
        '2022-02-24'),
       ((SELECT MAX(po.id) + 2 FROM person_order po),
        (SELECT p.id FROM person p WHERE p.name = 'Irina'),
        20,
        '2022-02-24');

-- SELECT * FROM person_order;
-- SELECT * FROM menu;
/*
INSERT 0 2
*/

-- FILE ./ex11/day03_ex11.sql

UPDATE menu
   SET price = price * 0.9
 WHERE pizza_name = 'greek pizza';

-- SELECT * FROM menu WHERE pizza_name = 'greek pizza';
/*
UPDATE 1
*/

-- FILE ./ex12/day03_ex12.sql

INSERT INTO person_order
SELECT (SELECT MAX(po.id) + gs.id FROM person_order po),
       gs.id,
       (SELECT id FROM menu WHERE pizza_name = 'greek pizza'),
       '2022-02-25'
  FROM GENERATE_SERIES(1, (SELECT COUNT(id) FROM person)) AS gs(id);

-- SELECT * FROM person_order;
/*
INSERT 0 9
*/

-- FILE ./ex13/day03_ex13.sql

DELETE
  FROM person_order
 WHERE order_date = '2022-02-25';

DELETE
  FROM menu
 WHERE pizza_name = 'greek pizza';

-- SELECT * FROM person_order WHERE order_date = '2022-02-25';
-- SELECT * FROM menu WHERE pizza_name = 'greek pizza';
/*
DELETE 9
DELETE 1
*/
