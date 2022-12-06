-- FILE ./ex00/day01_ex00.sql

SELECT p.id AS object_id, p.name AS object_name
FROM person p
UNION
SELECT m.id, m.pizza_name
FROM menu m
ORDER BY object_id ASC, object_name ASC;
/*
 object_id |   object_name   
-----------+-----------------
         1 | Anna
         1 | cheese pizza
         2 | Andrey
         2 | pepperoni pizza
         3 | Kate
         3 | sausage pizza
         4 | Denis
         4 | supreme pizza
         5 | Elvira
         5 | cheese pizza
         6 | Irina
         6 | pepperoni pizza
         7 | Peter
         7 | sausage pizza
         8 | Nataly
         8 | cheese pizza
         9 | Dmitriy
         9 | mushroom pizza
        10 | cheese pizza
        11 | supreme pizza
        12 | cheese pizza
        13 | mushroom pizza
        14 | pepperoni pizza
        15 | sausage pizza
        16 | cheese pizza
        17 | pepperoni pizza
        18 | supreme pizza
        20 | sicilian pizza
(28 rows)
*/

-- FILE ./ex01/day01_ex01.sql

SELECT p.name AS object_name
FROM person p
UNION ALL
SELECT m.pizza_name
FROM menu m
ORDER BY object_name;
/*
   object_name   
-----------------
 Andrey
 Anna
 Denis
 Dmitriy
 Elvira
 Irina
 Kate
 Nataly
 Peter
 cheese pizza
 cheese pizza
 cheese pizza
 cheese pizza
 cheese pizza
 cheese pizza
 mushroom pizza
 mushroom pizza
 pepperoni pizza
 pepperoni pizza
 pepperoni pizza
 pepperoni pizza
 sausage pizza
 sausage pizza
 sausage pizza
 sicilian pizza
 supreme pizza
 supreme pizza
 supreme pizza
(28 rows)
*/

-- FILE ./ex02/day01_ex02.sql

SELECT m1.pizza_name
FROM menu m1
UNION
SELECT m2.pizza_name
FROM menu m2
ORDER BY pizza_name DESC;
/*
   pizza_name    
-----------------
 supreme pizza
 sicilian pizza
 sausage pizza
 pepperoni pizza
 mushroom pizza
 cheese pizza
(6 rows)
*/

-- FILE ./ex03/day01_ex03.sql

SELECT po.order_date AS action_date, po.person_id
FROM person_order po
INTERSECT
SELECT pv.visit_date, pv.person_id
FROM person_visits pv
ORDER BY action_date ASC, person_id DESC;
/*
 action_date | person_id 
-------------+-----------
 2022-01-01  |         6
 2022-01-01  |         2
 2022-01-01  |         1
 2022-01-03  |         7
 2022-01-04  |         3
 2022-01-05  |         7
 2022-01-06  |         8
 2022-01-07  |         8
 2022-01-07  |         4
 2022-01-08  |         4
 2022-01-09  |         9
 2022-01-09  |         5
 2022-01-10  |         9
 2022-02-24  |         6
 2022-02-24  |         4
(15 rows)
*/

-- FILE ./ex04/day01_ex04.sql

SELECT po.person_id
FROM person_order po
WHERE po.order_date = '2022-01-07'
EXCEPT ALL
SELECT pv.person_id
FROM person_visits pv
WHERE pv.visit_date = '2022-01-07';
/*
 person_id 
-----------
         4
         4
(2 rows)
*/

-- FILE ./ex05/day01_ex05.sql

SELECT *
FROM person p
         CROSS JOIN pizzeria pz
ORDER BY p.id, pz.id;
/*
*/

-- FILE ./ex06/day01_ex06.sql

SELECT i.action_date, p.name
FROM (
         (SELECT po.order_date AS action_date, po.person_id
          FROM person_order po
          INTERSECT
          SELECT pv.visit_date, pv.person_id
          FROM person_visits pv) AS i
             JOIN
             (SELECT name, id
              FROM person) AS p
         ON i.person_id = p.id
         )
ORDER BY action_date ASC, name DESC;
/*
 action_date |  name   
-------------+---------
 2022-01-01  | Irina
 2022-01-01  | Anna
 2022-01-01  | Andrey
 2022-01-03  | Peter
 2022-01-04  | Kate
 2022-01-05  | Peter
 2022-01-06  | Nataly
 2022-01-07  | Nataly
 2022-01-07  | Denis
 2022-01-08  | Denis
 2022-01-09  | Elvira
 2022-01-09  | Dmitriy
 2022-01-10  | Dmitriy
 2022-02-24  | Irina
 2022-02-24  | Denis
(15 rows)
*/

-- FILE ./ex07/day01_ex07.sql

SELECT po.order_date, p.name || ' (age:' || p.age || ')' AS person_information
FROM person_order po
         JOIN person p
              ON po.person_id = p.id
ORDER BY po.order_date ASC, p.name ASC;

/*
 order_date | person_information 
------------+--------------------
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Irina (age:21)
 2022-01-03 | Peter (age:24)
 2022-01-04 | Kate (age:33)
 2022-01-05 | Peter (age:24)
 2022-01-05 | Peter (age:24)
 2022-01-06 | Nataly (age:30)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Nataly (age:30)
 2022-01-08 | Denis (age:13)
 2022-01-08 | Denis (age:13)
 2022-01-09 | Dmitriy (age:18)
 2022-01-09 | Elvira (age:45)
 2022-01-09 | Elvira (age:45)
 2022-01-10 | Dmitriy (age:18)
 2022-02-24 | Denis (age:13)
 2022-02-24 | Irina (age:21)
(22 rows)
*/

-- FILE ./ex08/day01_ex08.sql

SELECT order_date, name || ' (age:' || age || ')' AS person_information
FROM (SELECT po.person_id, po.order_date
      FROM person_order po) AS poa
         NATURAL JOIN (SELECT p.id AS person_id, p.name, p.age
                       FROM person p) AS pa
ORDER BY order_date ASC, name ASC;
/*
 order_date | person_information 
------------+--------------------
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Irina (age:21)
 2022-01-03 | Peter (age:24)
 2022-01-04 | Kate (age:33)
 2022-01-05 | Peter (age:24)
 2022-01-05 | Peter (age:24)
 2022-01-06 | Nataly (age:30)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Nataly (age:30)
 2022-01-08 | Denis (age:13)
 2022-01-08 | Denis (age:13)
 2022-01-09 | Dmitriy (age:18)
 2022-01-09 | Elvira (age:45)
 2022-01-09 | Elvira (age:45)
 2022-01-10 | Dmitriy (age:18)
 2022-02-24 | Denis (age:13)
 2022-02-24 | Irina (age:21)
(22 rows)
*/

-- FILE ./ex09/day01_ex09.sql

SELECT pz.name
FROM pizzeria pz
WHERE id NOT IN (SELECT pv.pizzeria_id
                 FROM person_visits pv);

SELECT pz.name
FROM pizzeria pz
WHERE NOT EXISTS(
        SELECT pv.pizzeria_id
        FROM person_visits pv
        WHERE pv.pizzeria_id = pz.id
    );
/*
 name 
------
(0 rows)

 name 
------
(0 rows)
*/

-- FILE ./ex10/day01_ex10.sql

SELECT p.name AS person_name, m.pizza_name, pz.name AS pizzeria_name
FROM person_order po
         JOIN person p
              ON po.person_id = p.id
         JOIN menu m
              ON po.menu_id = m.id
         JOIN pizzeria pz
              ON m.pizzeria_id = pz.id
ORDER BY p.name ASC, m.pizza_name ASC;
/*
 person_name |   pizza_name    | pizzeria_name 
-------------+-----------------+---------------
 Andrey      | cheese pizza    | Dominos
 Andrey      | mushroom pizza  | Dominos
 Anna        | cheese pizza    | Pizza Hut
 Anna        | pepperoni pizza | Pizza Hut
 Denis       | cheese pizza    | Best Pizza
 Denis       | pepperoni pizza | Best Pizza
 Denis       | pepperoni pizza | DinoPizza
 Denis       | sausage pizza   | DinoPizza
 Denis       | sicilian pizza  | Dominos
 Denis       | supreme pizza   | Best Pizza
 Dmitriy     | pepperoni pizza | DinoPizza
 Dmitriy     | supreme pizza   | Best Pizza
 Elvira      | pepperoni pizza | DinoPizza
 Elvira      | sausage pizza   | DinoPizza
 Irina       | mushroom pizza  | Papa Johns
 Irina       | sicilian pizza  | Dominos
 Kate        | cheese pizza    | Best Pizza
 Nataly      | cheese pizza    | Dominos
 Nataly      | pepperoni pizza | Papa Johns
 Peter       | mushroom pizza  | Dominos
 Peter       | sausage pizza   | Pizza Hut
 Peter       | supreme pizza   | Pizza Hut
(22 rows)
*/