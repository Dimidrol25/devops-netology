## Задача 1  

- **В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?**  
Режим `global` используется для развертывания, как правило, служебного сервиса, необходимого для каждой ноды в кластере и не требующий резервирования, например, мониторинг хоста (ноды).  
Режим `replication` используется для резервирования микросервисов в кластере и не важно на какой ноде будет крутится реплика сервиса.  
  

- **Какой алгоритм выбора лидера используется в Docker Swarm кластере?**  
`Raft` - это алгоритм, который решает проблему согласованности для того, чтобы все ноды в режиме `manager` имели одинаковое представление о состоянии кластера. Среди manager-нод выбирается лидер, его задача гарантировать согласованность. Лидер отправляет keepalive-пакеты с заданной периодичностью в пределах 150-300мс. Если ответ не пришел, manager-ноды начинают выборы нового лидера.  

  
- **Что такое Overlay Network?**
Overlay-сети используются в контексте кластеров (Docker Swarm), где виртуальная сеть, которую используют контейнеры, связывает несколько физических или виртуальных хостов, на которых запущен Docker.

## Задача 2  

![avatar](https://skrinshoter.ru/i/100822/PtdQzEXq.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2011-08-2022%2000:41:29.png) 

## Задача 3  

![avatar](https://skrinshoter.ru/i/100822/A5rXeA6C.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2011-08-2022%2000:42:25.png)  

## Задача 4  

Функция `autolock` используется для защиты от злоуммышленников ключа шифрования TLS и ключ для шифрования и дешифрования журналов Raft.

Включаем функцию `autolock`  
```
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-FM7Tcp1WqpKWBwjsMPdeWJWxhuLqmfoPdoNiqBG37OU

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
````

Перезапускаем `docker`. Демон не стартует, так как заблокирован. Нода в кластере соответственно в статусе `Down`.  
````
dimidrol@netology:~/virt-homeworks-virt-11/05-virt-05-docker-swarm/src/terraform$ ssh centos@51.250.1.199
[centos@node02 ~]$ sudo -i
[root@node02 ~]# sudo service docker restart
Redirecting to /bin/systemctl restart docker.service
[root@node02 ~]# docker service ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swa rm unlock" to unlock it.
[root@node02 ~]# docker swarm unlock
Please enter unlock key:
[root@node02 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                           PORTS
iwhwywd17l6f   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14. 0
qep5vtl8os7i   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                       *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
				.....
````
После разблокировки, нода снова в статусе `Ready`  

