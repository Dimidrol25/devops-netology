### Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."  

## Задача 1 (Вариант с Yandex.Cloud).  

Регистрация в Яндекс.Облаке была на прошлых занятиях.  

```
dimidrol@netology:~/devops-netology/terraform$ yc config list
token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
cloud-id: b1gb43cj4e37kp6cb04i
folder-id: b1gb4me0dlrtq7d9gg49
compute-default-zone: ru-central1-a
```

## Задача 2. Создание yandex_compute_instance через терраформ.

После инициализации `yc init` создал сервисную учетную запись в веб-интерфейсе с правами `Editor`, затем через `CLI` создал `IAM key`:  
```
dimidrol@netology:~/devops-netology/terraform$ yc iam key create --service-account-id aje0n1p6l4nj1s7hios2  --output key.json
id: aje2hvn1j3063bsmpath
service_account_id: aje0n1p6l4nj1s7hios2
created_at: "2022-09-19T14:26:59.453378960Z"
key_algorithm: RSA_2048
```

Запускаем `terraform plan`:
```
dimidrol@netology:~/devops-netology/terraform$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8c00efhiopj3rlnlbn]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm will be created
  + resource "yandex_compute_instance" "vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTb8Ly3Uul8v5U/y3/vI7vB3oFhI3tMj3U5U+/nqyN1s1kGN46Bzx8CDR80ddHMud7jM9ya/OHpxVVCElp9i/40LPAZMNq6nIGiWhS0pfl950ky+VWtor3XJfygdRfi/h+Lp8mrXOGIauXgOKgd5b/IUQtUieb2z+1DcV8wl4x7n8Yw84GX5U/Wfa9r450fr39H+LPV35HdVKKD/KEJ+5xwD0qmtDD1sQKQMjgLe//zbMDw7QaEL84A2OeZoCD3jNYj3o6HOhQgkmtZ/sv7e8TR32BLOrwy5Bmn600HbfEcD4AgL3Bak7LQHHJbtUaUOprxgdN71DtDtY/b5Bz3JIejkuCxnTssdLxqUnDhWCJg2I9qezy8h2rmDbLz3ggYnYfEBsoiE6bdqba+z3OIx0lK7IN3hAxmZ+Znizsi14i/oE+lum3bf9QMzPeVk3o7EDOwbKEKAPT3m1QhtwLh8nrKBiENV2WlMDATEyz35N/5f6UCVPHc2W98k+lAREnjPs= dimidrol@netology
            EOT
        }
      + name                      = "netology"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8c00efhiopj3rlnlbn"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet will be created
  + resource "yandex_vpc_subnet" "subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
`packer`
2. https://github.com/Dimidrol25/devops-netology/tree/main/terraform
