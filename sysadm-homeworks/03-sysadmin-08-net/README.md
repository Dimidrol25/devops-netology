## Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"  
***
### 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP.  
telnet route-views.routeviews.org  
![avatar](https://skrinshoter.ru/i/190722/0TGr6D4m.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-07-2022%2023:02:54.png)  
### 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.  
Создал конфигурационный файл `/etc/netplan/02-dummy.yaml`  
> network:  
> &nbsp;version: 2  
> &nbsp;&nbsp;  renderer: networkd  
> &nbsp;&nbsp;  bridges:  
>   &nbsp; &nbsp;&nbsp; dummy0:  
>  &nbsp; &nbsp;&nbsp;&nbsp;    dhcp4: no  
>  &nbsp; &nbsp;&nbsp;&nbsp;    dhcp6: no  
>   &nbsp;&nbsp;&nbsp;&nbsp;    accept-ra: no  
>  &nbsp;&nbsp;&nbsp;&nbsp;     interfaces: [ ]  
>  &nbsp; &nbsp;&nbsp;&nbsp;    addresses:  
>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       - 192.168.138.1/32  

`netplan apply`  

![avatar](https://skrinshoter.ru/i/190722/2EHlZY4A.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-07-2022%2023:18:01.png)  

Добавление статических маршрутов в `netplan`
>network:  
> &nbsp;version: 2  
> &nbsp;ethernets:  
>  &nbsp;&nbsp; eth0:  
>   &nbsp;&nbsp;&nbsp;  dhcp4: true  
>    &nbsp;&nbsp;&nbsp; routes:  
>     &nbsp;&nbsp;&nbsp;&nbsp;  - to: 192.168.132.0/24  
>   &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;     via: 10.0.2.2  
>   &nbsp;&nbsp;&nbsp;&nbsp;    - to: 87.250.250.242/32  
> &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;       via: 10.0.2.2  

`netplan apply`  

![avatar](https://skrinshoter.ru/i/190722/A1O6rcXD.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-07-2022%2023:53:05.png)  

### 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.  
![avatar](https://skrinshoter.ru/i/190722/RQrPGHfk.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-07-2022%2023:28:37.png)  

### 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?  
![avatar](https://skrinshoter.ru/i/190722/gPks7FCW.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-07-2022%2023:30:09.png)  

### 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.  
![avatar](https://raw.githubusercontent.com/Dimidrol25/devops-netology/main/home.png)


