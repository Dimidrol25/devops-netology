## Домашнее задание к занятию "3.4. Операционные системы, лекция 2".  
***
### 1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:  
- поместите его в автозагрузку: 
Скопировал исполняемый файл `node_exporter` в `/usr/local/bin/`

В `/lib/systemd/system/` создал Unit-файл `node_exporter.service` следующего содержания:
> [Unit]  
> Description=Node_exporter  
>   
> [Service]  
> EnvironmentFile=/etc/node_exporter/node_exporter  
> ExecStart=/usr/local/bin/node_exporter* $OPTIONS  
>   
> [Install]  
> WantedBy=multi-user.target  

Затем командой `systemctl enable node_exporter.service` добавил в автозагрузку:  
> root@vagrant:# systemctl enable node_exporter.service  
> Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /lib/systemd/system/node_exporter.service.  
  
После перезагрузки сервис поднялся автоматически.  

### 2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
CPU:  
- node_load1 
- node_load5  
- node_load15  
- node_cpu_seconds_total{cpu="0",mode="iowait"}  
- node_cpu_seconds_total{cpu="1",mode="iowait"}  
Память:  
- node_memory_MemAvailable_bytes  
- node_memory_MemFree_bytes  
- node_memory_MemTotal_bytes  
Диск:  
- node_filesystem_avail_bytes  
- node_filesystem_size_bytes  
- node_disk_io_now  
- node_disk_read_time_seconds_total  
- node_disk_write_time_seconds_total  
Сеть:  
- node_network_speed_bytes  
- node_network_transmit_bytes_total  
- node_network_up  

### 3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (`sudo apt install -y netdata`). После успешной установки:  
- в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,  
- добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:  
`config.vm.network "forwarded_port", guest: 19999, host: 19999`  

Установка через пакет не удалась. Установил через `kickstart`:  
> bash <(curl -Ss https://my-netdata.io/kickstart.sh)

Секцию `[web]` исправлять не пришлось, так как там стояло значение `*`. Дашборд и метрики изучил.

### 4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  
Да, можно. Если ОС загружена на системе виртуализации, то это отобразится в параметре `"Hypervisor detected"`. Если на физической машине, то этого параметра просто не будет.  
> vagrant@vagrant:$ dmesg | grep "Hypervisor detected"  
> [    0.000000] Hypervisor detected: KVM  

### 5. Как настроен `sysctl fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?  
`ulimit` обеспечивает контроль над ресурсами, доступными оболочке и процессам. 
`sysctl fs.nr_open` - это системный лимит на количество открытых дескрипторов. По умолчанию он равен 1048576 (1024*1024). 
По умолчанию "мягкий лимит" равен 1024, что и будет лимитом, который не позволит достичь числа `fs.nr_open`.  
> vagrant@vagrant:$ ulimit -n  
> 1024  

### 6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.  
![avatar](https://skr.sh/i/180722/Wel3zQup.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2018-07-2022%2017:55:08.jpg)  

### 7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (*это важно, поведение в других ОС не проверялось*). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?  
>В действительности эта команда является логической бомбой. Она оперирует определением функции с именем ‘:‘, которая вызывает сама себя дважды: один раз на переднем плане и один раз в фоне. Она продолжает своё выполнение снова и снова, пока система не зависнет.  
`dmesg` сообщил, что fork был отброшен PID-контроллером:  
`[Fri Jul 15 15:26:46 2022] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-2.scope`
