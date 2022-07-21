## Домашнее задание к занятию "3.5. Файловые системы"  
***
### 1. Узнайте о sparse (разряженных) файлах.  
Разреженные – это специальные файлы, которые с большей эффективностью используют файловую систему, они не позволяют ФС занимать свободное дисковое пространство носителя, когда разделы не заполнены. То есть, «пустое место» будет задействовано только при необходимости. Пустая информация в виде нулей, будет хранится в блоке метаданных ФС. Поэтому, разреженные файлы изначально занимают меньший объем носителя, чем их реальный объем.  

Самым большим преимуществом разреженных файлов является то, что пользователь может создавать файлы большого размера, которые занимают очень мало места для хранения. Пространство для хранения выделяется автоматически по мере записи на него данных. Разреженные файлы большого объема создаются за относительно короткое время, поскольку файловой системе не требуется предварительно выделять дисковое пространство для записи нулей.  

Еще один из недостатков — это то, что нельзя скопировать или создать такой файл, если его номинальный размер превышает доступный объем свободного пространства (или ограничения размера квоты, налагаемые на учетные записи пользователей). Например, если исходный размер (со всеми нулевыми байтами) составляет 500 МБ, а для учетной записи пользователя, используемой для его создания, существует предел квоты в 400 МБ. Это приведет к ошибке даже если фактическое дисковое пространство, занимаемое им, составляет всего 50 МБ на диске.  

### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?  
Протестировал опытным путем. Файлы, являющиеся жесткой ссылкой на один объект не могут иметь разные права доступа и владельца. При изменении атрибутов одного файла, у второго также меняются свойства, так как по сути это один и тот же файл и оба файла находятся в одной inode.  

### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:  
```
Vagrant.configure("2") do |config|  
  config.vm.box = "bento/ubuntu-20.04"  
  config.vm.provider :virtualbox do |vb|  
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"  
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"  
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]  
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]  
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]  
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]  
  end  
end
```  
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  

Виртуальную машину уничтожил, новая  с данной конфигурацией поднялась.  

### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.  
```
fdisk /dev/sdb  
Command (m for help): m  
n   add a new partition  
Partition type  
   p   primary (0 primary, 0 extended, 4 free)  
Partition number (1-4, default 1): 1  
First sector (2048-5242879, default 2048): 2048  
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G  
 
Created a new partition 1 of type 'Linux' and of size 2 GiB.
 
Command (m for help): m  
n   add a new partition  
Partition type  
   p   primary (0 primary, 0 extended, 4 free)  
Partition number (1-4, default 1): 2  
First sector (2048-5242879, default 4196352): 2048  
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879):  
 
Created a new partition 1 of type 'Linux' and of size 511 MiB.  
Command (m for help): m  
w   write table to disk and exit  

The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.  
```
Перезагружаем таблицу разделов:  
`partprobe /dev/sdb`  

![avatar](https://skr.sh/i/210722/Qxy25N1h.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2018:42:02.jpg)  

### 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.  
Сначала необходимо сделать дамп таблицы разделов с первого диска:
```
sfdisk --dump /dev/sdb > sdb.dump  
```
Затем этот дамп восстанавливаем на второй диск:  
```
root@vagrant:/home/vagrant# sfdisk /dev/sdc < sdb.dump  
Checking that no-one is using this disk right now ... OK  

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors  
Disk model: VBOX HARDDISK  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  

>>> Script header accepted.  
>>> Script header accepted.  
>>> Script header accepted.  
>>> Script header accepted.  
>>> Created a new DOS disklabel with disk identifier 0x57305d5d.  
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.  
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.  
/dev/sdc3: Done.  

New situation:  
Disklabel type: dos  
Disk identifier: 0x57305d5d  

Device     Boot   Start     End Sectors  Size Id Type  
/dev/sdc1          2048 4196351 4194304    2G 83 Linux  
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux  

The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.  
```
Перезагружаем таблицу разделов:  
`partprobe /dev/sdb`  

![avatar](https://skr.sh/i/210722/b44zKJTG.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2019:26:34.jpg)  

### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.  
```
root@vagrant:/home/vagrant# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[bc]1  
mdadm: Note: this array has metadata at the start and  
    may not be suitable as a boot device.  If you plan to  
    store '/boot' on this device please ensure that  
    your boot-loader understands md/v1.x metadata, or use  
    --metadata=0.90  
Continue creating array? y  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md0 started.  
```

![avatar](https://skrinshoter.ru/i/210722/DlonilgJ.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2022:01:40.png)  

### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.  
```
root@vagrant:/home/vagrant# mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sd[bc]2  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md1 started.  
```

![avatar](https://skrinshoter.ru/i/210722/ObevYPgq.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2022:06:57.png)  

### 8. Создайте 2 независимых PV на получившихся md-устройствах.  
```
root@vagrant:/home/vagrant# pvcreate /dev/md0 /dev/md1  
WARNING: dos signature detected on /dev/md0 at offset 510. Wipe it? [y/n]: y  
  Wiping dos signature on /dev/md0.  
WARNING: dos signature detected on /dev/md1 at offset 510. Wipe it? [y/n]: y  
  Wiping dos signature on /dev/md1.  
  Physical volume "/dev/md0" successfully created.  
  Physical volume "/dev/md1" successfully created.  
root@vagrant:/home/vagrant# pvscan  
  PV /dev/sda3   VG ubuntu-vg       lvm2 [<62.50 GiB / 31.25 GiB free]  
  PV /dev/md0                       lvm2 [<2.00 GiB]  
  PV /dev/md1                       lvm2 [1018.00 MiB]  
  Total: 3 [<65.49 GiB] / in use: 1 [<62.50 GiB] / in no VG: 2 [2.99 GiB]  
```

### 9. Создайте общую volume-group на этих двух PV.  

![avatar](https://skrinshoter.ru/i/210722/bs0YuoYn.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2023:27:21.png)

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.  

![avatar](https://skrinshoter.ru/i/210722/JVOzNNIR.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2023:44:05.png)

### 11. Создайте mkfs.ext4 ФС на получившемся LV.  
```
root@vagrant:/home/vagrant# mkfs.ext4 /dev/mapper/vol_grp1-lv--1  
mke2fs 1.45.5 (07-Jan-2020)  
Creating filesystem with 25600 4k blocks and 25600 inodes  

Allocating group tables: done  
Writing inode tables: done  
Creating journal (1024 blocks): done  
Writing superblocks and filesystem accounting information: done  
```

```
root@vagrant:/home/vagrant# blkid /dev/mapper/vol_grp1-lv--1
/dev/mapper/vol_grp1-lv--1: UUID="8801f818-0d0d-4630-a864-09348c61387c" TYPE="ext4"
```

### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.  

![avatar](https://skrinshoter.ru/i/210722/Q7H8aZCi.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2021-07-2022%2023:53:50.png)

### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.  

- [X] Скачал  

### 14. Прикрепите вывод lsblk.  

![avatar](https://skrinshoter.ru/i/210722/S7xVUABm.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2022-07-2022%2000:02:16.png)

### 15. Протестируйте целостность файла:  
```
root@vagrant:~# gzip -t /tmp/new/test.gz  
root@vagrant:~# echo $?  
0  
```
- [X] аналогично  

### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.  

![avatar](https://skrinshoter.ru/i/210722/3nK8M1o0.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2022-07-2022%2000:08:36.png)  

### 17. Сделайте --fail на устройство в вашем RAID1 md.  

```
root@vagrant:/home/vagrant# mdadm --fail /dev/md0 /dev/sdb1  
mdadm: set /dev/sdb1 faulty in /dev/md0  
```

### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.  


![avatar](https://skrinshoter.ru/i/210722/7KiwQSZ8.png?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2022-07-2022%2000:16:29.png)  

### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:  
```
root@vagrant:~# gzip -t /tmp/new/test.gz  
root@vagrant:~# echo $?  
0  
```

Данные остались целыми.  

### 20. Погасите тестовый хост, vagrant destroy.  

Виртуальную машину уничтожил.  
