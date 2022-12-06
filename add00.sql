-- FILE ./team00_ex00.sql

-- Создаем таблицу для маршрутов
CREATE TABLE IF NOT EXISTS distances
    (
        id bigint NOT NULL
            PRIMARY KEY,
        point1 varchar NOT NULL,
        point2 varchar NOT NULL,
        cost bigint NOT NULL
    );

-- Наполняем маршрутами согласно графа,
-- без дублей, если есть a->b, то b->a нет.
INSERT INTO distances
VALUES (1, 'a', 'b', 10),
       (2, 'b', 'c', 35),
       (3, 'a', 'c', 15),
       (4, 'a', 'd', 20),
       (5, 'b', 'd', 25),
       (6, 'c', 'd', 30);

-- Создаем представление для маршрутов с дублями
CREATE OR REPLACE VIEW all_distances
AS
SELECT point1, point2, cost
  FROM distances
 UNION
SELECT point2, point1, cost
  FROM distances
 ORDER BY point1, point2;

-- Создаем представление для туров
CREATE OR REPLACE VIEW tours
AS
  -- Рекурсивное СТЕ для формирования маршрутов
  -- https://learnsql.com/blog/sql-recursive-cte/
  WITH RECURSIVE paths AS (
        -- Первый запрос для формирования маршрута a->x (уровень 0)
        SELECT DISTINCT 'a,' || point2 AS points, cost, 0 AS level
          FROM all_distances
         WHERE point1 = 'a'
           AND point2 != 'a'
         UNION
        -- Остальные запросы для формирования маршрутов
        -- a->x->y (уровень 1) и a->x->y->z (уровень 2)
        SELECT DISTINCT points || ',' || point2 AS points, paths.cost + (
                SELECT cost FROM all_distances WHERE point1 = RIGHT(points, 1) AND point2 = a2.point2), level + 1
          FROM paths,
               all_distances a2
         WHERE POSITION(point2 IN points) = 0
           AND level < 2)
  -- Запрашиваем только маршруты a->x->y->z (уровня 2)
  -- и добавляем конечный пункт a и его стоимость
  SELECT cost + (SELECT cost FROM all_distances WHERE point1 = RIGHT(points, 1) AND point2 = 'a') AS total_cost,
         '{' || points || ',a}' AS tour
    FROM paths
   WHERE level = 2
   ORDER BY total_cost ASC, tour ASC;

-- Задание 1
SELECT *
  FROM tours
 WHERE total_cost = (SELECT MIN(total_cost) FROM tours);

-- Задание 2
SELECT *
  FROM tours;

-- Убираем за собой
DROP VIEW IF EXISTS tours;
DROP VIEW IF EXISTS all_distances;
DROP TABLE IF EXISTS distances;

/*
CREATE TABLE
CREATE VIEW
CREATE VIEW
 total_cost |    tour     
------------+-------------
         80 | {a,b,d,c,a}
         80 | {a,c,d,b,a}
(2 rows)

 total_cost |    tour     
------------+-------------
         80 | {a,b,d,c,a}
         80 | {a,c,d,b,a}
         95 | {a,b,c,d,a}
         95 | {a,c,b,d,a}
         95 | {a,d,b,c,a}
         95 | {a,d,c,b,a}
(6 rows)

DROP VIEW
DROP VIEW
DROP TABLE
*/
