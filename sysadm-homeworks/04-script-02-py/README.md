# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | TypeError: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | взять в двойные кавычки значения перменных  |
| Как получить для переменной `c` значение 3?  | b = 2  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

project_path = "~/devops-netology/"
bash_command = ['cd {0}'.format(project_path), "git status | grep modified"]
result_os = os.popen(' && '.join(bash_command)).read();
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
            prepare_result = result_os.replace('\tmodified:   ',f'{project_path}')
            print(f"Адрес репозитория: {project_path}", f"Измененные файлы: \n{prepare_result}", sep='\n\n')
            break
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagranttest:~$ ./py1.py  
Адрес репозитория: ~/devops-netology/  

Измененные файлы:  
~/devops-netology/README.md  
~/devops-netology/sysadm-homeworks/03-sysadmin-01-terminal/README.md  
~/devops-netology/sysadm-homeworks/03-sysadmin-02-terminal/README.md  
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

project_path = input("Введите путь к репозиторию: ")
bash_command = ['cd {0}'.format(project_path), "git status | grep modified"]
result_os = os.popen(' && '.join(bash_command)).read();
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
            prepare_result = result_os.replace('\tmodified:   ',f'{project_path}')
            print(f"Адрес репозитория: {project_path}", f"Измененные файлы: \n{prepare_result}", sep='\n\n')
            break
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagranttest:~$ ./py2.py  
Введите путь к репозиторию: /home/vagrant/devops-netology/  
Адрес репозитория: /home/vagrant/devops-netology/  

Измененные файлы:  
/home/vagrant/devops-netology/README.md  
/home/vagrant/devops-netology/sysadm-homeworks/03-sysadmin-01-terminal/README.md  
/home/vagrant/devops-netology/sysadm-homeworks/03-sysadmin-02-terminal/README.md  
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

ЭТО БЫЛО ПРЯМ СЛОЖНО......................  

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time

hosts = ['drive.google.com', 'google.com', 'mail.google.com']

hosts1_dict = dict.fromkeys(hosts, '0')

hosts2_dict = dict.fromkeys(hosts, '0')


while 1==1:

    for i in hosts2_dict.keys():
        ip = socket.gethostbyname(i)
        hosts2_dict[i] = ip
    #    print(i, '-', ip)

    for k,v in zip(hosts1_dict,hosts2_dict):
        if hosts1_dict[v] == hosts2_dict[v]:
            print(k, '-', hosts2_dict[v])
        else:
            print("ERROR", k, "IP missmatch", hosts1_dict[v], hosts2_dict[v])

    hosts1_dict.update(hosts2_dict)
    time.sleep(5)
```

### Вывод скрипта при запуске при тестировании:
````
vagrant@vagranttest:~$ ./py3_2.py
ERROR drive.google.com IP missmatch 0 74.125.131.194
ERROR google.com IP missmatch 0 142.251.1.102
ERROR mail.google.com IP missmatch 0 74.125.131.18
drive.google.com - 74.125.131.194
ERROR google.com IP missmatch 142.251.1.102 142.251.1.100
ERROR mail.google.com IP missmatch 74.125.131.18 74.125.131.17
drive.google.com - 74.125.131.194
google.com - 142.251.1.100
mail.google.com - 74.125.131.17
drive.google.com - 74.125.131.194
google.com - 142.251.1.100
mail.google.com - 74.125.131.17
drive.google.com - 74.125.131.194
google.com - 142.251.1.100
mail.google.com - 74.125.131.17
drive.google.com - 74.125.131.194
google.com - 142.251.1.100
mail.google.com - 74.125.131.17
drive.google.com - 74.125.131.194
ERROR google.com IP missmatch 142.251.1.100 142.251.1.139
mail.google.com - 74.125.131.17
^CTraceback (most recent call last):
  File "./py3_2.py", line 27, in <module>
    time.sleep(5)
KeyboardInterrupt

```
