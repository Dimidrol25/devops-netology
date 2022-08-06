## Процесс установки и настройки ufw  
```
# Проверяем статус  
dimidrol@netology:~$ sudo ufw status
Status: inactive
# Включаем ufw
dimidrol@netology:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
# Проверяем статус
dimidrol@netology:~$ sudo ufw status
Status: active
# Задаем политики по умолчанию для входящего (запрет) и исходящего трафика (разрешаем)
dimidrol@netology:~$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
dimidrol@netology:~$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
# Добавляем разрешающие правила для 22 и 443 портов
dimidrol@netology:~$ sudo ufw allow ssh
Rule added
Rule added (v6)
dimidrol@netology:~$ sudo ufw allow https
Rule added
Rule added (v6)
# Проверяем статус
dimidrol@netology:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
```
## Запускаем сервер VAULT  
```
dimidrol@netology:~$ vault server -dev -dev-root-token-id root
==> Vault server configuration:
             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.12
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.11.2, built 2022-07-29T09:48:47Z
             Version Sha: 3a8aa12eba357ed2de3192b15c99c717afdeb2b5
			....

Unseal Key: 9SnFi7o9g2RI8ESOzEkkAXcfOA6yz+LNlyRlrTqyGqg=
Root Token: root
```
 
Открываем новое окно терминала и продожаем настраивать    
 Настройка политики  
`dimidrol@netology:~$ tee admin-policy.hcl <<EOF`
```
# Enable secrets engine

path "sys/mounts/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# List enabled secrets engine

path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Work with pki secrets engine

path "pki*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
> EOF
# Enable secrets engine

path "sys/mounts/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# List enabled secrets engine

path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Work with pki secrets engine

path "pki*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
```
```
dimidrol@netology:~$ vault policy write admin admin-policy.hcl
Success! Uploaded policy: admin
dimidrol@netology:~$ export VAULT_ADDR=http://127.0.0.1:8200
dimidrol@netology:~$ export VAULT_TOKEN=root

# Generate root CA
dimidrol@netology:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
dimidrol@netology:~$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/

# Создание корневого сертификата
dimidrol@netology:~$ vault write -field=certificate pki/root/generate/internal \
>      common_name="example.com" \
>      issuer_name="root-2022" \
>      ttl=87600h > root_2022_ca.crt
dimidrol@netology:~$ vault list pki/issuers/
Keys
----
705962ae-4e50-12a8-cf6d-59d8283d625f
dimidrol@netology:~$ vault read pki/issuer/705962ae-4e50-12a8-cf6d-59d8283d625f \
>     | tail -n 6
issuer_id                  705962ae-4e50-12a8-cf6d-59d8283d625f
issuer_name                root-2022
key_id                     e74c433d-a988-4b26-9637-0aec59c4071e
leaf_not_after_behavior    err
manual_chain               <nil>
usage                      read-only,issuing-certificates,crl-signing

# Создание роли для корневого центра сертификации
dimidrol@netology:~$ vault write pki/roles/2022-servers allow_any_name=true
Success! Data written to: pki/roles/2022-servers

# Настройка путей
dimidrol@netology:~$ vault write pki/config/urls \
>      issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
>      crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls

# Generate intermediate CA
dimidrol@netology:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
dimidrol@netology:~$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/

# Подпись промежуточного сертификата
dimidrol@netology:~$ vault write -format=json pki_int/intermediate/generate/internal \
>      common_name="example.com Intermediate Authority" \
>      issuer_name="example-dot-com-intermediate" \

# Подпись CSR
dimidrol@netology:~$ vault write -format=json pki/root/sign-intermediate \
>      issuer_ref="root-2022" \
>      csr=@pki_intermediate.csr \
>      format=pem_bundle ttl="43800h" \
>      | jq -r '.data.certificate' > intermediate.cert.pem
dimidrol@netology:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Key                 Value
---                 -----
imported_issuers    [d987b63f-9bc0-4f8a-6779-96a3070ada41 64860a56-2dd3-c73e-5b3c-050268ea9e4e]
imported_keys       <nil>
mapping             map[64860a56-2dd3-c73e-5b3c-050268ea9e4e: d987b63f-9bc0-4f8a-6779-96a3070ada41:a33d41fe-b02c-e129-6618-2a93699278a8]

# Create a role
dimidrol@netology:~$ vault write pki_int/roles/example-dot-com \
>      issuer_ref="$(vault read -field=default pki_int/config/issuers)" \
>      allowed_domains="example.com" \
>      allow_subdomains=true \
>      max_ttl="43800h"
Success! Data written to: pki_int/roles/example-dot-com

# Выпуск сертификата для поддомена test1.example.com сроком 1 месяц и экспорт в файлы
dimidrol@netology:~$ json_crt=`vault write -format=json pki_int/issue/example-dot-com common_name="test1.example.com" ttl="720h"`
dimidrol@netology:~$ echo $json_crt | jq -r '.data.certificate'>test1.example.com.crt
dimidrol@netology:~$ echo $json_crt | jq -r '.data.private_key'>test1.example.com.key
```
## Установка nginx
```
dimidrol@netology:~$ sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
dimidrol@netology:~$ curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
>     | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1561  100  1561    0     0    975      0  0:00:01  0:00:01 --:--:--   975
dimidrol@netology:~$ gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
      573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
uid                      nginx signing key <signing-key@nginx.com>

dimidrol@netology:~$ echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
> http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
>     | sudo tee /etc/apt/sources.list.d/nginx.list
deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu focal nginx
dimidrol@netology:~$ echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
> http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
>     | sudo tee /etc/apt/sources.list.d/nginx.list
deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu focal nginx
dimidrol@netology:~$ echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
>     | sudo tee /etc/apt/preferences.d/99nginx
Package: *
Pin: origin nginx.org
Pin: release o=nginx
Pin-Priority: 900

dimidrol@netology:~$ sudo apt update 
dimidrol@netology:~$ sudo apt install nginx
dimidrol@netology:~$ sudo systemctl start nginx
dimidrol@netology:~$ sudo systemctl start nginx
```
 
## Настройка https
Создаем папку для сертификатов  
`dimidrol@netology:~$ sudo mkdir /etc/nginx/ssl`

Копируем файлы сертификата и ключа в созданную папку
`dimidrol@netology:~$ sudo cp ~/test1.example.com.* /etc/nginx/ssl/`

Исправляем конфигурационный файл для работы по https
```
server {
    listen       443 ssl;
    server_name  test1.example.com;
    ssl_certificate     /etc/nginx/ssl/test1.example.com.crt;
    ssl_certificate_key     /etc/nginx/ssl/test1.example.com.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
```
dimidrol@netology:/etc/nginx/ssl$ sudo nginx -t  
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
nginx: configuration file /etc/nginx/nginx.conf test is successful  
dimidrol@netology:/etc/nginx/ssl$ sudo nginx -s reload  
```
После импорта корневого и промежуточного сертификата в хостовую систему: 

![avatar](https://skrinshoter.ru/i/060822/iboC4phf.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2006-08-2022%2020:39:20.png)

![avatar](https://skrinshoter.ru/i/060822/OCzTjymh.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2006-08-2022%2020:51:59.png)

 Скрипт
```
#!/bin/bash
json_cert=`vault write -format=json pki_int/issue/example-dot-com common_name="test1.example.com" ttl="720h"`
echo $json_cert | jq -r '.data.certificate' > test1.example.com.crt
echo $json_cert | jq -r '.data.private_key' > test1.example.com.key
cp /home/dimidrol/test1.example.com.* /etc/nginx/ssl
systemctl restart nginx
```
 Скрипт в crontab работает  
`18 19   6 8 7   root    sh /home/dimidrol/revoke.sh`


