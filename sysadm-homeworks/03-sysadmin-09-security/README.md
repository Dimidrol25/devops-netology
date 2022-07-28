## Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"  
***
### 1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей. 

Установил, пароли сохранил.  

### 2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  

Приложением уже пользовался. Настроил двухфакторную аутентифкацию через oogle authenticator OTP.  

### 3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  
Установил, сгенерировал, настроил согласно инструкции в презентации. Промучался, когда стучался на 127.0.0.1, через мост все работает.  

![avatar](https://skr.sh/i/250722/Jtj38slV.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2025-07-2022%2011:58:53.jpg)   

### 4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).  
Воспользовался программой `testssl` для проверки уязвимостей. Протестировал корпоративный портал, нашел одну уязвимость:  

![avatar](https://skr.sh/i/250722/cptNuQkc.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2025-07-2022%2012:13:49.jpg)  

### 5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  
SSH-сервер установлен по умолчанию. Другим сервером выступил физический ПК с `PuTTY`. Сгенерировал публичный ключ и приватный ключ в `PuTTYgen`. Подключение по ssh-ключу прошло успешно.  

![avatar](https://skr.sh/i/250722/W6ERbxeZ.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2025-07-2022%2012:25:16.jpg)  

Также сгенерировал ключ по инструкции из презентации, добавил на удаленный сервер.  

### 6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.  
Переимновал файлы ключей, создал `config`:
```
User vagrant  
HostName 192.168.132.181  
Port 22  
IdentityFile ~/.ssh/vagrant  
```
Подключение по имени работает:  

![avatar](https://skrinshoter.ru/i/260722/sgvlh3hu.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2027-07-2022%2001:26:05.png)

### 7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.  
```
vagrant@vagrant:~$ sudo tcpdump -c 100 -w 3.9.7.pcap  
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes  
100 packets captured  
101 packets received by filter  
0 packets dropped by kernel  
```  

![avatar](https://skr.sh/i/250722/NJI8nFFj.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2025-07-2022%2013:09:28.jpg)
