-- FILE ./ex00/day05_ex00.sql

CREATE INDEX IF NOT EXISTS idx_menu_pizzeria_id ON menu (pizzeria_id);
CREATE INDEX IF NOT EXISTS idx_person_order_person_id ON person_order(person_id);
CREATE INDEX IF NOT EXISTS idx_person_order_menu_id ON person_order(menu_id);
CREATE INDEX IF NOT EXISTS idx_person_visits_person_id ON person_visits(person_id);
CREATE INDEX IF NOT EXISTS idx_person_visits_pizzeria_id ON person_visits(pizzeria_id);
/*
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
*/

-- FILE ./ex01/day05_ex01.sql

SET enable_seqscan = on;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT m.pizza_name, pz.name
  FROM menu m
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id;
/*
Hash Join  (cost=1.43..22.75 rows=19 width=64) (actual rows=19 loops=1)
  Hash Cond: (pz.id = m.pizzeria_id)
  ->  Seq Scan on pizzeria pz  (cost=0.00..18.10 rows=810 width=40) (actual rows=6 loops=1)
  ->  Hash  (cost=1.19..1.19 rows=19 width=40) (actual rows=19 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 10kB
        ->  Seq Scan on menu m  (cost=0.00..1.19 rows=19 width=40) (actual rows=19 loops=1)
Planning Time: 0.073 ms
Execution Time: 0.037 ms
*/

SET enable_seqscan = off;
SET max_parallel_workers_per_gather = 0;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT m.pizza_name, pz.name
  FROM menu m
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id;
/*
Nested Loop  (cost=0.29..63.61 rows=19 width=64) (actual rows=19 loops=1)
  ->  Index Scan using idx_menu_pizzeria_id on menu m  (cost=0.14..12.42 rows=19 width=40) (actual rows=19 loops=1)
  ->  Index Scan using pizzeria_pkey on pizzeria pz  (cost=0.15..2.69 rows=1 width=40) (actual rows=1 loops=19)
        Index Cond: (id = m.pizzeria_id)
Planning Time: 0.072 ms
Execution Time: 0.156 ms
*/

-- FILE ./ex02/day05_ex02.sql

CREATE INDEX IF NOT EXISTS idx_person_name ON person (UPPER(name));

SET enable_seqscan = off;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT * FROM person WHERE UPPER(name) = 'ANDREY';
/*
Index Scan using idx_person_name on person  (cost=0.14..8.15 rows=1 width=108) (actual rows=1 loops=1)
  Index Cond: (upper((name)::text) = 'ANDREY'::text)
Planning Time: 0.039 ms
Execution Time: 0.023 ms
*/

-- FILE ./ex03/day05_ex03.sql

CREATE INDEX IF NOT EXISTS idx_person_order_multi ON person_order (person_id, menu_id);

SET enable_seqscan = off;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT person_id, menu_id, order_date
  FROM person_order
 WHERE person_id = 8
   AND menu_id = 19;

/*
Index Scan using idx_person_order_multi on person_order  (cost=0.14..8.16 rows=1 width=20) (actual rows=0 loops=1)
  Index Cond: ((person_id = 8) AND (menu_id = 19))
Planning Time: 0.703 ms
Execution Time: 0.072 ms
*/

-- FILE ./ex04/day05_ex04.sql

CREATE UNIQUE INDEX IF NOT EXISTS idx_menu_unique ON menu (pizzeria_id, pizza_name);

SET enable_seqscan = off;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT *
  FROM menu
 WHERE pizzeria_id = 1
   AND pizza_name = 'pepperoni pizza';
/*
Index Scan using idx_menu_unique on menu  (cost=0.14..8.16 rows=1 width=80) (actual rows=1 loops=1)
  Index Cond: ((pizzeria_id = 1) AND ((pizza_name)::text = 'pepperoni pizza'::text))
Planning Time: 0.073 ms
Execution Time: 0.037 ms
*/

-- FILE ./ex05/day05_ex05.sql

CREATE INDEX IF NOT EXISTS idx_person_order_order_date
    ON person_order (person_id, menu_id)
    WHERE order_date = '2022-01-01';

SET enable_seqscan = off;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT * FROM person_order WHERE order_date = '2022-01-01';
/*
Index Scan using idx_person_order_order_date on person_order  (cost=0.13..8.15 rows=1 width=28) (actual rows=5 loops=1)
Planning Time: 0.047 ms
Execution Time: 0.015 ms
*/

-- FILE ./ex06/day05_ex06.sql

SET enable_seqscan = off;
SET max_parallel_workers_per_gather = 0;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT
    m.pizza_name AS pizza_name,
    max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
FROM  menu m
INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
ORDER BY 1,2;
/*
Sort  (cost=64.80..64.85 rows=19 width=96) (actual rows=19 loops=1)
"  Sort Key: m.pizza_name, (max(pz.rating) OVER (?))"
  Sort Method: quicksort  Memory: 26kB
  ->  WindowAgg  (cost=64.01..64.39 rows=19 width=96) (actual rows=19 loops=1)
        ->  Sort  (cost=64.01..64.06 rows=19 width=64) (actual rows=19 loops=1)
              Sort Key: pz.rating
              Sort Method: quicksort  Memory: 26kB
              ->  Nested Loop  (cost=0.29..63.61 rows=19 width=64) (actual rows=19 loops=1)
                    ->  Index Only Scan using idx_menu_unique on menu m  (cost=0.14..12.42 rows=19 width=40) (actual rows=19 loops=1)
                          Heap Fetches: 19
                    ->  Index Scan using pizzeria_pkey on pizzeria pz  (cost=0.15..2.69 rows=1 width=40) (actual rows=1 loops=19)
                          Index Cond: (id = m.pizzeria_id)
Planning Time: 0.088 ms
Execution Time: 0.106 ms
*/

-- CREATE INDEX idx_pizzeria_max_rating ON pizzeria(rating);
-- CREATE INDEX idx_1 ON pizzeria(id, rating);
CREATE INDEX idx_1 ON pizzeria(rating, id);

EXPLAIN (ANALYZE, TIMING OFF)
SELECT
    m.pizza_name AS pizza_name,
    max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
FROM  menu m
INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
ORDER BY 1,2;
/*
Sort  (cost=25.95..26.00 rows=19 width=96) (actual rows=19 loops=1)
"  Sort Key: m.pizza_name, (max(pz.rating) OVER (?))"
  Sort Method: quicksort  Memory: 26kB
  ->  WindowAgg  (cost=0.27..25.54 rows=19 width=96) (actual rows=19 loops=1)
        ->  Nested Loop  (cost=0.27..25.21 rows=19 width=64) (actual rows=19 loops=1)
              ->  Index Only Scan using idx_1 on pizzeria pz  (cost=0.13..12.22 rows=6 width=40) (actual rows=6 loops=1)
                    Heap Fetches: 6
              ->  Index Only Scan using idx_menu_unique on menu m  (cost=0.14..2.15 rows=1 width=40) (actual rows=3 loops=6)
                    Index Cond: (pizzeria_id = pz.id)
                    Heap Fetches: 19
Planning Time: 0.205 ms
Execution Time: 0.099 ms
*/
