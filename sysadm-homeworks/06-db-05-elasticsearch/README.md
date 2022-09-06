### Домашнее задание к занятию "6.5. Elasticsearch"  

## Задача 1  

- текст Dockerfile манифеста:  
В связи со сложившейся ситуацией пришлось использовать прокси для закачки дистрибутива `elastisearch`

```
FROM centos:7

EXPOSE 9200 9300

USER 0

RUN export ES_HOME="/var/lib/elasticsearch" && \
    yum -y install wget epel-release &&  yum -y install proxychains-ng && \
    sed -i 's/127.0.0.1/192.168.17.149/g' /etc/proxychains.conf && \
    proxychains wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.1-linux-x86_64.tar.gz && \
    proxychains wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.1-linux-x86_64.tar.gz.sha512 && \
    sha512sum -c elasticsearch-8.4.1-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.4.1-linux-x86_64.tar.gz && \
    rm -f elasticsearch-8.4.1-linux-x86_64.tar.gz* && \
    mv elasticsearch-8.4.1 ${ES_HOME} && \
    useradd -m -u 1000 elasticsearch && \
    chown elasticsearch:elasticsearch -R ${ES_HOME} && \
    yum clean all

USER 1000

ENV ES_HOME="/var/lib/elasticsearch" \
    ES_PATH_CONF="/var/lib/elasticsearch/config"
WORKDIR ${ES_HOME}

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]

```  

- ссылка на образ в репозитории dockerhub:  
https://hub.docker.com/repository/docker/dimidrol25/devops-elasticsearch  

- ответ elasticsearch на запрос пути / в json виде:
`curl -XGET https://127.0.0.1:9200 --insecure -u "elastic:elastic"`  
```
{
  "name" : "97199bd70e7c",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "g3AiyoaaS4SUzusJXJSaIA",
  "version" : {
    "number" : "8.4.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "2bd229c8e56650b42e40992322a76e7914258f0c",
    "build_date" : "2022-08-26T12:11:43.232597118Z",
    "build_snapshot" : false,
    "lucene_version" : "9.3.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```  

## Задача 2  

добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:  

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
root@netology:/home/dimidrol/elk# curl -X PUT https://127.0.0.1:9200/ind-1?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
{
"settings": {
"number_of_shards": 1,
"number_of_replicas": 0
}
}
'

{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
```
```
root@netology:/home/dimidrol/elk# curl -X PUT https://127.0.0.1:9200/ind-2?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
{
"settings": {
"number_of_shards": 2,
"number_of_replicas": 1
}
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
```
```
root@netology:/home/dimidrol/elk# curl -X PUT https://127.0.0.1:9200/ind-3?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
{
"settings": {
"number_of_shards": 4,
"number_of_replicas": 2
}
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```  

Получите список индексов и их статусов, используя API и приведите в ответе на задание.  

```
root@netology:/home/dimidrol/elk# curl https://127.0.0.1:9200/_cat/indices?v --insecure -u "elastic:elastic"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 ycVA2gZ6ROOyIbbnYmG7Qw   1   0          0            0       225b           225b
yellow open   ind-3 HAEN7WgJRhmd0CYi9Ble_A   4   2          0            0       900b           900b
yellow open   ind-2 WgUMuPP4Qn6G-VgD2wKHZg   2   1          0            0       450b           450b
```

Получите состояние кластера elasticsearch, используя API.  

```
root@netology:/home/dimidrol/elk# curl -X GET https://127.0.0.1:9200/_cluster/health?pretty --insecure -u "elastic:elastic"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?  
Первичный шард и реплика не могут находиться на одном узле, если копия не назначена, поэтому один узел не может размещать копии.  

Удаление индексов:  
```
root@netology:/home/dimidrol/elk# curl -XDELETE https://127.0.0.1:9200/ind-1,ind-2,ind-3 --insecure -u "elastic:elastic"
root@netology:/home/dimidrol/elk# curl https://127.0.0.1:9200/_cat/indices?v --insecure -u "elastic:elastic"
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```

## Задача 3  

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.  
```
docker exec -u root -it elastic bash
[root@97199bd70e7c elasticsearch]# mkdir $ES_HOME/snapshots
```

Используя API зарегистрируйте данную директорию как `snapshot repository` c именем `netology_backup`.  
```
[root@97199bd70e7c elasticsearch]# echo path.repo: [ "/var/lib/elasticsearch/snapshots" ] >> "$ES_HOME/config/elasticsearch.yml"
[root@97199bd70e7c elasticsearch]# chown elasticsearch:elasticsearch /var/lib/elasticsearch/snapshots

root@netology:/home/dimidrol/elk# docker restart elastic1
elastic1

root@netology:/home/dimidrol/elk# curl -X PUT https://127.0.0.1:9200/_snapshot/netology_backup?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
> {
> "type": "fs",
> "settings": {
> "location": "/var/lib/elasticsearch/snapshots",
> "compress": true
> }
> }'
{
  "acknowledged" : true
}
```

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
root@netology:/home/dimidrol/elk# curl -X PUT https://127.0.0.1:9200/test?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
> {
> "settings": {
> "number_of_shards": 1,
> "number_of_replicas": 0
> }
> }'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}

root@netology:/home/dimidrol/elk# curl https://127.0.0.1:9200/_cat/indices?v --insecure -u "elastic:elastic"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  KNvGsWfvSX2bW488DM7Iqw   1   0          0            0       225b           225b
```

Создайте `snapshot` состояния кластера `elasticsearch`.  
```
root@netology:/home/dimidrol/elk# curl -X PUT "https://127.0.0.1:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty" --insecure -u "elastic:elastic"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "QB7wh15kSo-xnepZ-Pz4Vg",
    "repository" : "netology_backup",
    "version_id" : 8040199,
    "version" : "8.4.1",
    "indices" : [
      "test",
      ".security-7",
      ".geoip_databases"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-09-06T20:49:21.704Z",
    "start_time_in_millis" : 1662497361704,
    "end_time" : "2022-09-06T20:49:23.444Z",
    "end_time_in_millis" : 1662497363444,
    "duration_in_millis" : 1740,
    "failures" : [ ],
    "shards" : {
      "total" : 3,
      "failed" : 0,
      "successful" : 3
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      },
      {
        "feature_name" : "security",
        "indices" : [
          ".security-7"
        ]
      }
    ]
  }
}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.  
```
root@netology:/home/dimidrol/elk# docker exec -it elastic1 ls -l /var/lib/elasticsearch/snapshots/
total 36
-rw-r--r-- 1 elasticsearch elasticsearch  1095 Sep  6 20:49 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Sep  6 20:49 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch  4096 Sep  6 20:49 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18538 Sep  6 20:49 meta-QB7wh15kSo-xnepZ-Pz4Vg.dat
-rw-r--r-- 1 elasticsearch elasticsearch   387 Sep  6 20:49 snap-QB7wh15kSo-xnepZ-Pz4Vg.dat
```

Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```
root@netology:/home/dimidrol/elk# curl -X DELETE https://127.0.0.1:9200/test?pretty --insecure -u "elastic:elastic"
{
  "acknowledged" : true
}
root@netology:/home/dimidrol/elk# curl -X PUT https://127.0.0.1:9200/test-2?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
> {
> "settings": {
> "number_of_shards": 1,
> "number_of_replicas": 0
> }
> }'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
root@netology:/home/dimidrol/elk# curl https://127.0.0.1:9200/_cat/indices?pretty --insecure -u "elastic:elastic"
green open test-2 pctP-_EcQyWl87q9tbnQkw 1 0 0 0 225b 225b
```

Восстановите состояние кластера `elasticsearch` из `snapshot`, созданного ранее.
```
root@netology:/home/dimidrol/elk# curl -X POST https://127.0.0.1:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty --insecure -u "elastic:elastic" -H 'Content-Type: application/json' -d'
> {
> "indices": "*",
> "include_global_state": true
> }'
{
  "accepted" : true
}
```

Приведите в ответе запрос к API восстановления и итоговый список индексов.
```
root@netology:/home/dimidrol/elk# curl https://localhost:9200/_cat/indices?pretty --insecure -u "elastic:elastic"
green open test-2 pctP-_EcQyWl87q9tbnQkw 1 0 0 0 225b 225b
green open test   XWZmgFPcRSa_qsMmUC4KTA 1 0 0 0 225b 225b
```
