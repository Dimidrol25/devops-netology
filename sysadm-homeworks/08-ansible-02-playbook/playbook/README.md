## 8.2 описание Playbook по заданию

### GROUP VARS  

`java_oracle_jdk_package` - имя пакета установки `Java`  
`java_jdk_version` - используемая версия `Java`  

`elastic_home` - переменная домашнего каталога для `Elasticsearch`  
`elastic_version` - версия `Elasticsearch`  

`kibana_home` - переменная для домашнего каталога для `Kibana`  
`kibana_version` - версия `Kibana`  

## Описание Play 

### Install Java  

 Установлены тэги `java` для дальнейшего использования и отладки  
 - установка переменных (facts)  
 - загрузка установосного пакета  
 - создние рабочего каталога  
 - распаковка пакета  
 - создание по шаблону переменных окружений (templates)  

### Install Elastic

 Установлены тэги `elastic` для дальнейшего использования и отладки  
 - загрузка установочного пакета  
 - создание рабочего каталога  
 - распаковка в рабочий каталог из пакета  
 - создание по шаблону переменных окружений (templates)  

### install Kibana

 Установлены тэги *kibana* для дальнейшего использования и отладки  
 - загрузка установочного пакета  
 - создание рабочего каталога  
 - распаковка в рабочий каталог из пакета  
 - создание по шаблону переменных окружений (templates)  
