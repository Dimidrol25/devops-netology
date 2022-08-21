## Задача 1  

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.  

```
mysql> \s
--------------
mysql  Ver 8.0.30 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          250
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.30
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/lib/mysql/mysql.sock
Binary data as:         Hexadecimal
Uptime:                 1 hour 56 min 2 sec

Threads: 2  Questions: 472  Slow queries: 0  Opens: 139  Flush tables: 3  Open tables: 58  Queries per second avg: 0.067
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
```
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```

Приведите в ответе количество записей с price > 300.
```
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.  
```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.  
```
mysql> SHOW TABLE STATUS FROM mysql LIKE 'plugin'\G;
*************************** 1. row ***************************
           Name: plugin
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 0
 Avg_row_length: 0
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 4194304
 Auto_increment: NULL
    Create_time: 2022-08-20 19:39:39
    Update_time: NULL
     Check_time: NULL
      Collation: utf8mb3_general_ci
       Checksum: NULL
 Create_options: row_format=DYNAMIC stats_persistent=0
        Comment: MySQL plugins
1 row in set (0.01 sec)
```
Используется Engine InnoDB  

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        9 | 0.00504900 | SHOW TABLE STATUS FROM mysql LIKE 'plugin'                                              |
|       10 | 0.00128825 | show tables                                                                             |
|       11 | 0.03590825 | ALTER TABLE orders ENGINE = MyISAM                                                      |
|       12 | 0.00221625 | SHOW TABLE STATUS FROM mysql LIKE 'plugin'                                              |
|       13 | 0.00122800 | SHOW TABLE STATUS FROM test_db LIKE 'plugin'                                            |
|       14 | 0.00116075 | show databases                                                                          |
|       15 | 0.00124575 | SHOW TABLE STATUS FROM test_db LIKE 'plugin'                                            |
|       16 | 0.00028125 | SELECT DATABASE()                                                                       |
|       17 | 0.00121450 | SHOW TABLE STATUS FROM test_db LIKE 'plugin'                                            |
|       18 | 0.00119350 | SHOW TABLE STATUS FROM test_db LIKE 'plugin'                                            |
|       19 | 0.00032625 | SHOW ENGINES                                                                            |
|       20 | 0.00041625 | SHOW ENGINES                                                                            |
|       21 | 0.00106250 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db' |
|       22 | 0.03659850 | ALTER TABLE orders ENGINE = InnoDB                                                      |
|       23 | 0.00118800 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db' |
+----------+------------+-----------------------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)
```

## Задача 4

```
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M
```
