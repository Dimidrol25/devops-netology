
# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",	
        "elements" :[					# Пропущен пробел между :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175					# Неверный форма ip-адреса, пропущена запятая
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43				# Не закрыт ключ двойными кавычками
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

Переделал скрипт из предыдущей задачи на словари.  

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import json
import yaml

hosts = ['drive.google.com', 'google.com', 'mail.google.com']

hosts1_dict = dict.fromkeys(hosts, '0')

hosts2_dict = dict.fromkeys(hosts, '0')

while 1 == 1:

    for i in hosts2_dict.keys():
        hosts2_dict[i] = socket.gethostbyname(i)

    for k,v in zip(hosts1_dict,hosts2_dict):
        if hosts1_dict[v] == hosts2_dict[v]:
            print(k, '-', hosts2_dict[v])
        else:
            print("ERROR", k, "IP missmatch", hosts1_dict[v], hosts2_dict[v])

    hosts1_dict.update(hosts2_dict)

    with open("test.json", 'w') as f:
       json.dump(hosts2_dict, f, indent=2)

    with open("test.yaml", 'w') as f:
       yaml_dump = yaml.dump(hosts2_dict, f, explicit_start=True, explicit_end=True)

    time.sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagranttest:~$ ./py7.py
ERROR drive.google.com IP missmatch 0 64.233.165.194
ERROR google.com IP missmatch 0 142.251.1.100
ERROR mail.google.com IP missmatch 0 74.125.131.18
drive.google.com - 64.233.165.194
ERROR google.com IP missmatch 142.251.1.100 142.251.1.101
ERROR mail.google.com IP missmatch 74.125.131.18 74.125.131.17
^CTraceback (most recent call last):
  File "./py7.py", line 33, in <module>
    time.sleep(5)
KeyboardInterrupt
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
vagrant@vagranttest:~$ cat test.json
{
  "drive.google.com": "64.233.165.194",
  "google.com": "142.251.1.101",
  "mail.google.com": "74.125.131.17"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
vagrant@vagranttest:~$ cat test.yaml
---
drive.google.com: 64.233.165.194
google.com: 142.251.1.101
mail.google.com: 74.125.131.17
...
```



