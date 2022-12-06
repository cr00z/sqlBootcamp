-- FILE ./ex00/day07_ex00.sql

SELECT pv.person_id, COUNT(*) AS count_of_visits
  FROM person_visits pv
 GROUP BY pv.person_id
 ORDER BY count_of_visits DESC, pv.person_id ASC;

/*
 person_id | count_of_visits 
-----------+-----------------
         9 |               4
         4 |               3
         6 |               3
         8 |               3
         2 |               2
         3 |               2
         5 |               2
         7 |               2
         1 |               1
(9 rows)
*/

-- FILE ./ex01/day07_ex01.sql

WITH pvg AS (
  SELECT pv.person_id, COUNT(*) AS count_of_visits
    FROM person_visits pv
GROUP BY pv.person_id
)
SELECT p.name, pvg.count_of_visits
  FROM pvg
           JOIN person p
           ON pvg.person_id = p.id
 ORDER BY pvg.count_of_visits DESC, pvg.person_id ASC
 LIMIT 4;
/*
  name   | count_of_visits 
---------+-----------------
 Dmitriy |               4
 Denis   |               3
 Irina   |               3
 Nataly  |               3
(4 rows)
*/

-- FILE ./ex02/day07_ex02.sql

SELECT name, count, action_type
  FROM (
  (SELECT m.pizzeria_id, COUNT(*) AS count, 'order' AS action_type
     FROM person_order po
            JOIN menu m
            ON m.id = po.menu_id
    GROUP BY m.pizzeria_id
    ORDER BY count DESC
    LIMIT 3)
   UNION
  (SELECT pv.pizzeria_id, COUNT(*) AS count, 'visit'
     FROM person_visits pv
    GROUP BY pv.pizzeria_id
    ORDER BY count DESC
    LIMIT 3)) AS agg
          JOIN pizzeria pz
            ON pz.id = agg.pizzeria_id
 ORDER BY action_type ASC, count DESC;

/*
    name    | count | action_type 
------------+-------+-------------
 Dominos    |     6 | order
 Best Pizza |     5 | order
 DinoPizza  |     5 | order
 Dominos    |     7 | visit
 DinoPizza  |     4 | visit
 Pizza Hut  |     4 | visit
(6 rows)
*/

-- FILE ./ex03/day07_ex03.sql

SELECT pz.name, sum.total_count
  FROM (SELECT agg.pizzeria_id, SUM(count) AS total_count
          FROM (SELECT pv.pizzeria_id, COUNT(*) AS count
                  FROM person_visits pv
                 GROUP BY pv.pizzeria_id
                 UNION
                SELECT m.pizzeria_id, COUNT(*) AS count
                  FROM person_order po
                           JOIN menu m
                           ON po.menu_id = m.id
                 GROUP BY m.pizzeria_id) AS agg
         GROUP BY agg.pizzeria_id) AS sum
           JOIN pizzeria pz
           ON pz.id = sum.pizzeria_id
 ORDER BY total_count DESC, name ASC;
/*
    name    | total_count 
------------+-------------
 Dominos    |          13
 DinoPizza  |           9
 Best Pizza |           8
 Papa Johns |           5
 Pizza Hut  |           4
 DoDo Pizza |           1
(6 rows)
*/

-- FILE ./ex04/day07_ex04.sql

SELECT p.name, agg.count AS count_of_visits
  FROM (
    SELECT pv.person_id, COUNT(*) AS count
    FROM person_visits pv
    GROUP BY pv.person_id
    HAVING COUNT(*) > 3
  ) AS agg
JOIN person p
ON agg.person_id = p.id;
/*
  name   | count_of_visits 
---------+-----------------
 Dmitriy |               4
(1 row)
*/

-- FILE ./ex05/day07_ex05.sql

SELECT DISTINCT p.name
  FROM person_order po
           JOIN person p
           ON p.id = po.person_id
 ORDER BY p.name;

SELECT p.name
  FROM person p
 WHERE p.id IN (SELECT po.person_id FROM person_order po)
 ORDER BY p.name;
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

-- FILE ./ex06/day07_ex06.sql

SELECT pz.name, agg.count_of_orders, agg.average_price, agg.max_price, agg.min_price
  FROM (SELECT m.pizzeria_id, COUNT(*) AS count_of_orders, ROUND(AVG(m.price), 2) AS average_price,
               MAX(m.price) AS max_price, MIN(m.price) AS min_price
          FROM person_order po
                   JOIN menu m
                   ON po.menu_id = m.id
         GROUP BY m.pizzeria_id) AS agg
  JOIN pizzeria pz
    ON pz.id = agg.pizzeria_id
 ORDER BY pz.name;
/*
    name    | count_of_orders | average_price | max_price | min_price 
------------+-----------------+---------------+-----------+-----------
 Best Pizza |               5 |        780.00 |       850 |       700
 DinoPizza  |               5 |        880.00 |      1000 |       800
 Dominos    |               6 |        933.33 |      1100 |       800
 Papa Johns |               2 |        975.00 |      1000 |       950
 Pizza Hut  |               4 |       1125.00 |      1200 |       900
(5 rows)
*/

-- FILE ./ex07/day07_ex07.sql

SELECT ROUND(AVG(pz.rating), 4) AS global_rating
  FROM pizzeria pz;
/*
 global_rating 
---------------
        3.4333
(1 row)
*/

-- FILE ./ex08/day07_ex08.sql

SELECT p.address, pz.name, COUNT(*) AS count_of_orders
  FROM person_order po
           JOIN menu m
           ON po.menu_id = m.id
           JOIN person p
           ON po.person_id = p.id
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id
 GROUP BY p.address, pz.name
 ORDER BY p.address, pz.name;
/*
     address      |    name    | count_of_orders 
------------------+------------+-----------------
 Kazan            | Best Pizza |               4
 Kazan            | DinoPizza  |               4
 Kazan            | Dominos    |               1
 Moscow           | Dominos    |               2
 Moscow           | Pizza Hut  |               2
 Novosibirsk      | Dominos    |               1
 Novosibirsk      | Papa Johns |               1
 Saint-Petersburg | Dominos    |               2
 Saint-Petersburg | Papa Johns |               1
 Saint-Petersburg | Pizza Hut  |               2
 Samara           | Best Pizza |               1
 Samara           | DinoPizza  |               1
(12 rows)
*/

-- FILE ./ex09/day07_ex09.sql

WITH agg AS (
    SELECT p.address, ROUND((MAX(p.age) - MIN(p.age)::float4 / MAX(p.age))::numeric, 2) AS formula,
           ROUND(AVG(p.age), 2) AS average
      FROM person p
     GROUP BY p.address
)
SELECT *, formula > average AS comparison FROM agg
ORDER BY agg.address;
/*
     address      | formula | average | comparison 
------------------+---------+---------+------------
 Kazan            |   44.71 |   30.33 | t
 Moscow           |   20.24 |   18.50 | t
 Novosibirsk      |   29.00 |   30.00 | f
 Saint-Petersburg |   23.13 |   22.50 | t
 Samara           |   17.00 |   18.00 | f
(5 rows)
*/