## Домашнее задание к занятию "08.02 Работа с Playbook"

### Подготовка к выполнению

1. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook.

```
---
elasticsearch:
  hosts:
    centos-el:
      ansible_host: 172.17.0.2
      ansible_connection: ssh
      ansible_user: root
      ansible_password: 12345678
kibana:
  hosts:
    centos-kb:
      ansible_host: 172.17.0.3
      ansible_connection: ssh
      ansible_user: root
      ansible_password: 12345678
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.

```
- name: Install kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz kibana from remote URL
      get_url:
        url: "https://github.com/elastic/elasticsearch/archive/refs/tags/v{{ elastic_version }}.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for kibana
      file:
        state: directory
        path: "{{ kibana_home }}"
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags:
        - skip_ansible_lint
        - kibana
    - name: Set environment Kibana
      become: true
      template:
        src: templates/kib.sh.j2
        dest: /etc/profile.d/kib.sh
      tags: kibana
```

5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
Ошибок нет.

6. Попробуйте запустить playbook на этом окружении с флагом --check.

![avatar](https://skrinshoter.ru/i/280922/8kjHdVSF.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2028-09-2022%2015:05:16.png)

7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.

![avatar](https://skrinshoter.ru/i/280922/l89JZ4tB.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2028-09-2022%2015:07:57.png)
![avatar](https://skrinshoter.ru/i/280922/eIrPBRQ7.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2028-09-2022%2015:09:00.png)

8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
![avatar]https://skrinshoter.ru/i/280922/rkcA0F9E.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2028-09-2022%2015:14:36.png

`playbook` идемпотентен.

10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.

https://github.com/Dimidrol25/devops-netology/tree/main/sysadm-homeworks/08-ansible-02-playbook/playbook
