## Задача 2  

**Итоговый список БД**  
```
test_db=# \l
                                  List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    |      Access privileges
-----------+-------+----------+------------+------------+-----------------------------
 admin     | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin                   +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin                   +
           |       |          |            |            | admin=CTc/admin
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/admin                  +
           |       |          |            |            | admin=CTc/admin            +
           |       |          |            |            | "test-admin-user"=CTc/admin
(5 rows)

```  

**Описание таблиц (describe)**  
```
test_db=# \d+ orders
                                                   Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 наименование | text    |           |          |                                    | extended |              |
 цена         | integer |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap  

test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 фамилия           | text    |           |          |                                     | extended |              |
 страна проживания | text    |           |          |                                     | extended |              |
 заказ             | integer |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```  

**SQL-запрос для выдачи списка пользователей с правами над таблицами test_db**  
```
SELECT 
    grantee, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 
    1,2,3;
```  

**список пользователей с правами над таблицами test_db**
```
     grantee      | table_name | privilege_type
------------------+------------+----------------
 test-simple-user | clients    | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
(8 rows)
```

## Задача 3

```
test_db=# SELECT COUNT(1) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(1) FROM clients;
 count
-------
     5
(1 row)
```

## Задача 4  

```
test_db=# UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Книга') WHERE фамилия = 'Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Монитор') WHERE фамилия = 'Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Гитара') WHERE фамилия = 'Иоганн Себастьян Бах';
UPDATE 1

test_db=# SELECT clients.*, orders.наименование FROM clients INNER JOIN orders ON clients.заказ = orders.id;
 id |       фамилия        | страна проживания | заказ | наименование
----+----------------------+-------------------+-------+--------------
  1 | Иванов Иван Иванович | USA               |     3 | Книга
  2 | Петров Петр Петрович | Canada            |     4 | Монитор
  3 | Иоганн Себастьян Бах | Japan             |     5 | Гитара
(3 rows)
```

## Задача 5  

```
test_db=# EXPLAIN SELECT clients.*, orders.наименование FROM clients INNER JOIN orders ON clients.заказ = orders.id;
                              QUERY PLAN
-----------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=104)
   Hash Cond: (clients."заказ" = orders.id)
   ->  Seq Scan on clients  (cost=0.00..18.10 rows=810 width=72)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
         ->  Seq Scan on orders  (cost=0.00..22.00 rows=1200 width=36)
(5 rows)
```

Команда `explain` показывает план запроса.  
Сначала `Hash Join` вызывает `Hash`, который в свою очередь вызывает `Seq Scan` по `clients`. Потом `Hash` создает в памяти хэш со строками из источника, хэшированными с помощью столбца `orders.id`. Затем `Hash` запускает `Seq Scan` по таблице `orders` и проверяет, есть ли ключ `join` (`clients."заказ"`) в хэше, возвращенном операцией `Hash`. Eсли нет, данная строка не будет возвращена. Если ключ существует, `Hash Join` берет строки из хэша и, основываясь на этой строке, с одной стороны, и всех строках хэша, с другой стороны, генерирует вывод строк.

## Задача 6  

**Бэкап БД**
```
root@00c57adf2636:/# pg_dump -U admin test_db > /postgres_backup/test_db_16082022.dump
```

Перед восстановлением необходимо создать БД, затем выполнить восстановление:
```
psql -U admin test_db < /postgres_backup/test_db_16082022.dump
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
ERROR:  role "test-simple-user" does not exist
ERROR:  role "test-simple-user" does not exist

```

Отсюда следует, что пользователи БД не архивируются вместе с БД с помощью данного способа..
