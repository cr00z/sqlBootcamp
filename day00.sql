-- FILE ./ex00/day00_ex00.sql

SELECT p.name, p.age
FROM person p
WHERE p.address = 'Kazan';
/*
  name  | age 
--------+-----
 Kate   |  33
 Denis  |  13
 Elvira |  45
(3 rows)
*/

-- FILE ./ex01/day00_ex01.sql

SELECT p.name, p.age
FROM person p
WHERE p.gender = 'female'
  AND p.address = 'Kazan'
ORDER BY p.name ASC;
/*
  name  | age 
--------+-----
 Elvira |  45
 Kate   |  33
(2 rows)
*/

-- FILE ./ex02/day00_ex02.sql

SELECT pz.name, pz.rating
FROM pizzeria pz
WHERE pz.rating >= 3.5
  AND pz.rating <= 5.0
ORDER BY pz.rating ASC;

SELECT pz.name, pz.rating
FROM pizzeria pz
WHERE pz.rating BETWEEN 3.5 AND 5.0
ORDER BY pz.rating ASC;
/*
    name    | rating 
------------+--------
 DinoPizza  |    4.2
 Papa Johns |    4.9
(2 rows)

    name    | rating 
------------+--------
 DinoPizza  |    4.2
 Papa Johns |    4.9
(2 rows)
*/

-- FILE ./ex03/day00_ex03.sql

SELECT DISTINCT pv.person_id
FROM person_visits pv
WHERE (pv.visit_date BETWEEN '2022-01-06' AND '2022-01-09')
   OR (pv.pizzeria_id = 2)
ORDER BY pv.person_id DESC;
/*
 person_id 
-----------
         9
         8
         7
         6
         5
         4
         2
(7 rows)
*/

-- FILE ./ex04/day00_ex04.sql

select p.name ||
       ' (age:' || p.age || ',' ||
       'gender:''' || p.gender || ''',' ||
       'address:''' || p.address || ''')'
           AS person_information
FROM person p
ORDER BY person_information ASC;
/*
                    person_information                     
-----------------------------------------------------------
 Andrey (age:21,gender:'male',address:'Moscow')
 Anna (age:16,gender:'female',address:'Moscow')
 Denis (age:13,gender:'male',address:'Kazan')
 Dmitriy (age:18,gender:'male',address:'Samara')
 Elvira (age:45,gender:'female',address:'Kazan')
 Irina (age:21,gender:'female',address:'Saint-Petersburg')
 Kate (age:33,gender:'female',address:'Kazan')
 Nataly (age:30,gender:'female',address:'Novosibirsk')
 Peter (age:24,gender:'male',address:'Saint-Petersburg')
(9 rows)
*/

-- FILE ./ex05/day00_ex05.sql

SELECT (SELECT p.name
        FROM person p
        WHERE p.id = po.person_id) AS name
FROM person_order po
WHERE (po.menu_id = 13 OR po.menu_id = 14 OR po.menu_id = 18)
  AND (po.order_date = '2022-01-07');
/*
  name  
--------
 Denis
 Nataly
(2 rows)
*/

-- FILE ./ex06/day00_ex06.sql

SELECT (SELECT p1.name
        FROM person p1
        WHERE p1.id = po.person_id),
       (SELECT CASE
                   WHEN p2.name = 'Denis' THEN true
                   ELSE false
                   END AS check_name
        FROM person p2
        WHERE p2.id = po.person_id)
FROM person_order po
WHERE (po.menu_id = 13 OR po.menu_id = 14 OR po.menu_id = 18)
  AND po.order_date = '2022-01-07';
/*
  name  | check_name 
--------+------------
 Denis  | t
 Nataly | f
(2 rows)
*/

-- FILE ./ex07/day00_ex07.sql

SELECT p.id,
       p.name,
       CASE
           WHEN p.age >= 10 AND p.age <= 20 THEN 'interval #1'
           WHEN p.age > 20 AND p.age < 24 THEN 'interval #2'
           ELSE 'interval #3'
           END AS interval_info
FROM person p
ORDER BY interval_info ASC;
/*
 id |  name   | interval_info 
----+---------+---------------
  1 | Anna    | interval #1
  4 | Denis   | interval #1
  9 | Dmitriy | interval #1
  6 | Irina   | interval #2
  2 | Andrey  | interval #2
  8 | Nataly  | interval #3
  5 | Elvira  | interval #3
  7 | Peter   | interval #3
  3 | Kate    | interval #3
(9 rows)
*/

-- FILE ./ex08/day00_ex08.sql

SELECT *
FROM person_order po
WHERE MOD(po.id, 2) = 0
ORDER BY po.id;
/*
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  2 |         1 |       2 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  6 |         4 |      16 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
 10 |         4 |       7 | 2022-01-08
 12 |         5 |       7 | 2022-01-09
 14 |         7 |       3 | 2022-01-03
 16 |         7 |       4 | 2022-01-05
 18 |         8 |      14 | 2022-01-07
 20 |         9 |       6 | 2022-01-10
 22 |         6 |      20 | 2022-02-24
(11 rows)
*/

-- FILE ./ex09/day00_ex09.sql

SELECT (SELECT p.name
        FROM person p
        WHERE p.id = pv.person_id)    AS person_name,
       (SELECT pz.name
        FROM pizzeria pz
        WHERE pz.id = pv.pizzeria_id) AS pizzeria_name
FROM (SELECT *
      FROM person_visits
      WHERE visit_date BETWEEN '2022-01-07' AND '2022-01-09') AS pv
ORDER BY person_name ASC, pizzeria_name DESC;
/*
 person_name | pizzeria_name 
-------------+---------------
 Denis       | DinoPizza
 Denis       | Best Pizza
 Dmitriy     | Papa Johns
 Dmitriy     | DoDo Pizza
 Dmitriy     | Best Pizza
 Elvira      | Dominos
 Elvira      | DinoPizza
 Irina       | Dominos
 Nataly      | Papa Johns
(9 rows)
*/