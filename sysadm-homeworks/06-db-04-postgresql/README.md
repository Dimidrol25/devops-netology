## Задача 1  

- вывода списка БД  
`\l`  
- подключения к БД  
`\c`  
- вывода списка таблиц  
`\d `  
- вывода описания содержимого таблиц  
`\dS+`  
- выхода из psql  
`\q`

## Задача 2  

```
test_database=# SELECT avg_width, attname FROM pg_stats WHERE tablename = 'orders' ORDER BY attname DESC LIMIT 1;
 avg_width | attname
-----------+---------
        16 | title
(1 row)

```

## Задача 3  

Для шардирования необходимо сначала партиционировать существующую таблицу. Для этого нужно ее пересоздать:  
```
test_database=# ALTER TABLE orders RENAME TO orders_p;
ALTER TABLE
test_database=# CREATE TABLE orders (id integer, title varchar(80), price integer) PARTITION BY range(price);
CREATE TABLE
test_database=# CREATE TABLE orders_1 PARTITION OF orders FOR values FROM (500) TO (2147483647);
CREATE TABLE
test_database=# CREATE TABLE orders_2 PARTITION OF orders FOR values FROM (0) to (499);
CREATE TABLE
test_database=# \d+ orders
                                    Partitioned table "public.orders"
 Column |         Type          | Collation | Nullable | Default | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+---------+----------+--------------+-------------
 id     | integer               |           |          |         | plain    |              |
 title  | character varying(80) |           |          |         | extended |              |
 price  | integer               |           |          |         | plain    |              |
Partition key: RANGE (price)
Partitions: orders_1 FOR VALUES FROM (500) TO (2147483647),
            orders_2 FOR VALUES FROM (0) TO (500)

test_database=# INSERT INTO orders_1 SELECT * FROM orders_p WHERE price >= 500;
INSERT 0 3

test_database=# INSERT INTO orders_2 SELECT * FROM orders_p WHERE price <= 499;
INSERT 0 5

test_database=# SELECT * FROM orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
(8 rows)
```
При проектировании таблиц можно было сделать партиционированную таблицу, тогда можно было бы сразу сделать секционирование.  

## Задача 4  

Бэкап БД:  
```
root@96818eb3b069:/# pg_dump -U admin -d test_database > /postgres/test_database_22-08-2022.sql
```

Для уникальности добавить индекс:  
```
CREATE INDEX ON orders ((lower(title)));
```
