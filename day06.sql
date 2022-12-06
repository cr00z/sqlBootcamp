-- FILE ./ex00/day06_ex00.sql

CREATE TABLE IF NOT EXISTS person_discounts
    (
        id bigint NOT NULL
            PRIMARY KEY,
        person_id bigint NOT NULL
            CONSTRAINT fk_person_discounts_person_id REFERENCES person,
        pizzeria_id bigint NOT NULL
            CONSTRAINT fk_person_discounts_pizzeria_id REFERENCES pizzeria,
        discount numeric DEFAULT 0 NOT NULL
    );
/*
CREATE TABLE
*/
-- FILE ./ex01/day06_ex01.sql

  WITH order_count AS (SELECT po.person_id, m.pizzeria_id, COUNT(*) AS count
                         FROM person_order po
                                  JOIN menu m
                                  ON po.menu_id = m.id
                        GROUP BY po.person_id, m.pizzeria_id)

INSERT INTO person_discounts
SELECT ROW_NUMBER() OVER (), oc.person_id, oc.pizzeria_id,
       CASE WHEN oc.count = 1 THEN 10.5 WHEN oc.count = 2 THEN 22 ELSE 30 END
  FROM order_count oc;

-- SELECT * FROM person_discounts;

-- FILE ./ex02/day06_ex02.sql

SELECT p.name, m.pizza_name, m.price, m.price * (100 - pd.discount) / 100, pz.name AS pizzeria_name
  FROM person_order po
           JOIN person p
           ON po.person_id = p.id
           JOIN menu m
           ON po.menu_id = m.id
           JOIN pizzeria pz
           ON m.pizzeria_id = pz.id
           JOIN person_discounts pd
           ON pd.person_id = p.id AND pd.pizzeria_id = pz.id
 ORDER BY p.name, m.pizza_name;
/*
  name   |   pizza_name    | price |       ?column?       | pizzeria_name 
---------+-----------------+-------+----------------------+---------------
 Andrey  | cheese pizza    |   800 | 624.0000000000000000 | Dominos
 Andrey  | mushroom pizza  |  1100 | 858.0000000000000000 | Dominos
 Anna    | cheese pizza    |   900 | 702.0000000000000000 | Pizza Hut
 Anna    | pepperoni pizza |  1200 | 936.0000000000000000 | Pizza Hut
 Denis   | cheese pizza    |   700 | 490.0000000000000000 | Best Pizza
 Denis   | pepperoni pizza |   800 | 560.0000000000000000 | Best Pizza
 Denis   | pepperoni pizza |   800 | 624.0000000000000000 | DinoPizza
 Denis   | sausage pizza   |  1000 | 780.0000000000000000 | DinoPizza
 Denis   | sicilian pizza  |   900 | 805.5000000000000000 | Dominos
 Denis   | supreme pizza   |   850 | 595.0000000000000000 | Best Pizza
 Dmitriy | pepperoni pizza |   800 | 716.0000000000000000 | DinoPizza
 Dmitriy | supreme pizza   |   850 | 760.7500000000000000 | Best Pizza
 Elvira  | pepperoni pizza |   800 | 624.0000000000000000 | DinoPizza
 Elvira  | sausage pizza   |  1000 | 780.0000000000000000 | DinoPizza
 Irina   | mushroom pizza  |   950 | 850.2500000000000000 | Papa Johns
 Irina   | sicilian pizza  |   900 | 805.5000000000000000 | Dominos
 Kate    | cheese pizza    |   700 | 626.5000000000000000 | Best Pizza
 Nataly  | cheese pizza    |   800 | 716.0000000000000000 | Dominos
 Nataly  | pepperoni pizza |  1000 | 895.0000000000000000 | Papa Johns
 Peter   | mushroom pizza  |  1100 | 984.5000000000000000 | Dominos
 Peter   | sausage pizza   |  1200 | 936.0000000000000000 | Pizza Hut
 Peter   | supreme pizza   |  1200 | 936.0000000000000000 | Pizza Hut
(22 rows)
*/

-- FILE ./ex03/day06_ex03.sql

CREATE UNIQUE INDEX IF NOT EXISTS idx_person_discounts_unique ON person_discounts(person_id, pizzeria_id);

SET enable_seqscan = off;

EXPLAIN (ANALYZE, TIMING OFF)
SELECT * FROM person_discounts WHERE person_id = 4 AND pizzeria_id = 6;
/*
Index Scan using idx_person_discounts_unique on person_discounts  (cost=0.14..8.15 rows=1 width=56) (actual rows=1 loops=1)
  Index Cond: ((person_id = 4) AND (pizzeria_id = 6))
Planning Time: 0.068 ms
Execution Time: 0.057 ms
*/

-- FILE ./ex04/day06_ex04.sql

ALTER TABLE person_discounts ADD CONSTRAINT ch_nn_person_id
    CHECK (person_id IS NOT NULL);
-- ALTER TABLE person_discounts ALTER COLUMN person_id SET NOT NULL;

ALTER TABLE person_discounts ADD CONSTRAINT ch_nn_pizzeria_id
    CHECK (pizzeria_id IS NOT NULL);

ALTER TABLE person_discounts ADD CONSTRAINT ch_nn_discount
    CHECK (discount IS NOT NULL);

ALTER TABLE person_discounts ALTER COLUMN discount SET DEFAULT 0;

ALTER TABLE person_discounts ADD CONSTRAINT ch_range_discount
    CHECK (discount BETWEEN 0 AND 100);

/*
ALTER TABLE
*/

-- FILE ./ex05/day06_ex05.sql

/*
Table of personal discounts for persons in pizzerias
---------------------------------------------------------------------
Columns:
id           primary key
person_id    foreign key for table `person`
pizzeria_id  foreign key for table `pizzeria`
discount     personal percentage discount (from 0 to 100, default 0)
---------------------------------------------------------------------
*/

CREATE TABLE IF NOT EXISTS person_discounts
    (
        id bigint NOT NULL
            PRIMARY KEY,
        person_id bigint NOT NULL
            CONSTRAINT fk_person_discounts_person_id REFERENCES person,
        pizzeria_id bigint NOT NULL
            CONSTRAINT fk_person_discounts_pizzeria_id REFERENCES pizzeria,
        discount numeric DEFAULT 0 NOT NULL
            CHECK (discount BETWEEN 0 AND 100)
    );
/*
CREATE TABLE
*/

-- FILE ./ex06/day06_ex06.sql

CREATE SEQUENCE IF NOT EXISTS seq_person_discounts START 1;
ALTER SEQUENCE seq_person_discounts OWNED BY person_discounts.id;

-- wrong request
SELECT NEXTVAL('seq_person_discounts');
INSERT INTO person_discounts
VALUES (NEXTVAL('seq_person_discounts'), 1, 2, 1);

-- correct request
SELECT SETVAL('seq_person_discounts', (SELECT MAX(id) FROM person_discounts));
ALTER TABLE person_discounts ALTER COLUMN id SET DEFAULT NEXTVAL('seq_person_discounts');
INSERT INTO person_discounts (person_id, pizzeria_id, discount)
VALUES (1, 2, 1);

-- SELECT SETVAL('seq_person_discounts', 1);
-- SELECT * FROM person_discounts;
-- DELETE FROM person_discounts WHERE id = 18;
