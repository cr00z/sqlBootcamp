-- FILE ./ex00/day08_ex00.sql

SHOW TRANSACTION ISOLATION LEVEL;

-- SESSION 1 --

BEGIN;
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
COMMIT;

SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
postgres=# SELECT NOW();
             now
-----------------------------
 2022-12-02 14:21:26.7949+07
(1 row)

postgres=# BEGIN;
BEGIN
postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:21:41.938394+07
(1 row)

postgres=*# UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)

postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:21:41.938394+07
(1 row)

postgres=*# COMMIT;
COMMIT
*/

-- SESSION 2 --

/*
 postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:22:43.576342+07
(1 row)

postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    4.6
(1 row)

postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:23:35.766689+07
(1 row)

postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)
 */


-- FILE ./ex01/day08_ex01.sql

SHOW TRANSACTION ISOLATION LEVEL;

-- SESSION 1 --

BEGIN;
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
postgres=# BEGIN;
BEGIN
postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:41:51.435052+07
(1 row)

postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)

postgres=*# UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# COMMIT;
COMMIT
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:43:57.082309+07
(1 row)

postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)
*/


-- SESSION 2 --

BEGIN;
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
postgres=# BEGIN;
BEGIN
postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:41:58.378795+07
(1 row)

postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)

postgres=*# UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# COMMIT;
COMMIT
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 14:44:01.585726+07
(1 row)

postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)
*/


-- FILE ./ex02/day08_ex02.sql

-- SESSION 1 --

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:13:29.205956+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION
postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)

postgres=*# UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# COMMIT;
COMMIT
postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      4
(1 row)
*/


-- SESSION 2 --

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
 postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:13:32.949618+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION
postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)

postgres=*# UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
ERROR:  could not serialize access due to concurrent update
postgres=!# COMMIT;
ROLLBACK
postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      4
(1 row)
 */


-- FILE ./ex03/day08_ex03.sql

-- SESSION 1 --

START TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
COMMIT;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:21:46.765815+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION
postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |      4
(1 row)

postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:21:58.765302+07
(1 row)

postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)

postgres=*# COMMIT;
COMMIT
postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)
*/


-- SESSION 2 --

START TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:21:45.125002+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION
postgres=*# UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:22:00.740543+07
(1 row)

postgres=*# COMMIT;
COMMIT
postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)
 */


-- FILE ./ex04/day08_ex04.sql

-- SESSION 1 --

START TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
COMMIT;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:31:59.042727+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION
postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)

postgres=*# SELECT NOW();
             now
------------------------------
 2022-12-02 15:32:14.96257+07
(1 row)

postgres=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)

postgres=*# COMMIT;
COMMIT
postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.0
(1 row)
*/


-- SESSION 2 --

START TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE pizzeria SET rating = 3.0 WHERE name = 'Pizza Hut';
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 15:31:59.442575+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION
postgres=*# UPDATE pizzeria SET rating = 3.0 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# COMMIT;
COMMIT
postgres=# SELECT NOW();
             now
------------------------------
 2022-12-02 15:32:53.53734+07
(1 row)

postgres=# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating
----+-----------+--------
  1 | Pizza Hut |    3.0
(1 row)
 */


-- FILE ./ex05/day08_ex05.sql

-- SESSION 1 --

SHOW TRANSACTION ISOLATION LEVEL;
BEGIN;
SELECT SUM(rating) FROM pizzeria;
SELECT SUM(rating) FROM pizzeria;
COMMIT;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:03:20.782113+07
(1 row)

postgres=# BEGIN;
BEGIN
postgres=*# SELECT SUM(rating) FROM pizzeria;
 sum
------
 21.9
(1 row)

postgres=*# SELECT SUM(rating) FROM pizzeria;
 sum
------
 19.9
(1 row)

postgres=*# COMMIT;
COMMIT
postgres=# SELECT SUM(rating) FROM pizzeria;
 sum
------
 19.9
(1 row)

postgres=# SELECT NOW();
             now
------------------------------
 2022-12-02 16:04:47.18075+07
(1 row)
*/


-- SESSION 2 --

BEGIN;
UPDATE pizzeria SET rating = 1 WHERE name = 'Pizza Hut';
COMMIT;
SELECT SUM(rating) FROM pizzeria;
/*
postgres=# SHOW TRANSACTION ISOLATION LEVEL;
 transaction_isolation
-----------------------
 read committed
(1 row)

postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:03:21.566126+07
(1 row)

postgres=# BEGIN;
BEGIN
postgres=*# UPDATE pizzeria SET rating = 1 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# COMMIT;
COMMIT
postgres=# SELECT SUM(rating) FROM pizzeria;
 sum
------
 19.9
(1 row)

postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:04:52.228451+07
(1 row)
 */


-- FILE ./ex06/day08_ex06.sql

-- SESSION 1 --

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT SUM(rating) FROM pizzeria;
SELECT SUM(rating) FROM pizzeria;
COMMIT;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:14:42.528505+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION
postgres=*# SELECT SUM(rating) FROM pizzeria;
 sum
------
 19.9
(1 row)

postgres=*# SELECT SUM(rating) FROM pizzeria;
 sum
------
 19.9
(1 row)

postgres=*# COMMIT;
COMMIT
postgres=# SELECT SUM(rating) FROM pizzeria;
 sum
------
 23.9
(1 row)

postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:16:11.478057+07
(1 row)
*/


-- SESSION 2 --

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
COMMIT;
SELECT SUM(rating) FROM pizzeria;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:14:43.328499+07
(1 row)

postgres=# START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION
postgres=*# UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
UPDATE 1
postgres=*# COMMIT;
COMMIT
postgres=# SELECT SUM(rating) FROM pizzeria;
 sum
------
 23.9
(1 row)

postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:16:12.813605+07
(1 row)
*/


-- FILE ./ex07/day08_ex07.sql

-- SESSION 1 --

BEGIN;
UPDATE pizzeria SET rating = 3 WHERE id = 1;
UPDATE pizzeria SET rating = 3 WHERE id = 2;
COMMIT;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:24:14.469153+07
(1 row)

postgres=# BEGIN;
BEGIN
postgres=*# UPDATE pizzeria SET rating = 3 WHERE id = 1;
UPDATE 1
postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:24:34.036411+07
(1 row)

postgres=*# UPDATE pizzeria SET rating = 3 WHERE id = 2;
UPDATE 1
postgres=*# COMMIT;
COMMIT
*/


-- SESSION 2 --

BEGIN;
UPDATE pizzeria SET rating = 2 WHERE id = 2;
UPDATE pizzeria SET rating = 2 WHERE id = 1;
COMMIT;

/*
postgres=# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:24:14.941331+07
(1 row)

postgres=# BEGIN;
BEGIN
postgres=*# UPDATE pizzeria SET rating = 2 WHERE id = 2;
UPDATE 1
postgres=*# SELECT NOW();
              now
-------------------------------
 2022-12-02 16:24:38.124285+07
(1 row)

postgres=*# UPDATE pizzeria SET rating = 2 WHERE id = 1;
ERROR:  deadlock detected
DETAIL:  Process 44266 waits for ShareLock on transaction 1059; blocked by process 44244.
Process 44244 waits for ShareLock on transaction 1060; blocked by process 44266.
HINT:  See server log for query details.
CONTEXT:  while updating tuple (0,28) in relation "pizzeria"
postgres=!# COMMIT;
ROLLBACK
*/
