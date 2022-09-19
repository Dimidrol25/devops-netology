### Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1.  

1. Создал бакет в `Yandex.Cloud`  

![avatar](https://skr.sh/i/190922/IS96jE8i.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-09-2022%2019:22:18.jpg)

2. Зарегистрируйте бэкэнд в терраформ  

![avatar](https://skr.sh/i/190922/NFatA4nw.jpg?download=1&name=%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%2019-09-2022%2019:24:03.jpg)

Сделал инициализацию `terraform`:  
```
dimidrol@netology:~/devops-netology/terraform$ terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.78.2

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

## Задача 2.  

Создал воркспейсы:  

```
dimidrol@netology:~/devops-netology/terraform$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
dimidrol@netology:~/devops-netology/terraform$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

Вывод команды `terraform workspace list`:  

```
dimidrol@netology:~/devops-netology/terraform$ terraform workspace list
  default
* prod
  stage
```

Вывод команды terraform plan для воркспейса prod:  

```
dimidrol@netology:~/devops-netology/terraform$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8c00efhiopj3rlnlbn]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.instance-1[0] will be created
  + resource "yandex_compute_instance" "instance-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-1.netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTb8Ly3Uul8v5U/y3/vI7vB3oFhI3tMj3U5U+/nqyN1s1kGN46Bzx8CDR80ddHMud7jM9ya/OHpxVVCElp9i/40LPAZMNq6nIGiWhS0pfl950ky+VWtor3XJfygdRfi/h+Lp8mrXOGIauXgOKgd5b/IUQtUieb2z+1DcV8wl4x7n8Yw84GX5U/Wfa9r450fr39H+LPV35HdVKKD/KEJ+5xwD0qmtDD1sQKQMjgLe//zbMDw7QaEL84A2OeZoCD3jNYj3o6HOhQgkmtZ/sv7e8TR32BLOrwy5Bmn600HbfEcD4AgL3Bak7LQHHJbtUaUOprxgdN71DtDtY/b5Bz3JIejkuCxnTssdLxqUnDhWCJg2I9qezy8h2rmDbLz3ggYnYfEBsoiE6bdqba+z3OIx0lK7IN3hAxmZ+Znizsi14i/oE+lum3bf9QMzPeVk3o7EDOwbKEKAPT3m1QhtwLh8nrKBiENV2WlMDATEyz35N/5f6UCVPHc2W98k+lAREnjPs= dimidrol@netology
            EOT
        }
      + name                      = "vm-prod-1"
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
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance-1[1] will be created
  + resource "yandex_compute_instance" "instance-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-2.netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTb8Ly3Uul8v5U/y3/vI7vB3oFhI3tMj3U5U+/nqyN1s1kGN46Bzx8CDR80ddHMud7jM9ya/OHpxVVCElp9i/40LPAZMNq6nIGiWhS0pfl950ky+VWtor3XJfygdRfi/h+Lp8mrXOGIauXgOKgd5b/IUQtUieb2z+1DcV8wl4x7n8Yw84GX5U/Wfa9r450fr39H+LPV35HdVKKD/KEJ+5xwD0qmtDD1sQKQMjgLe//zbMDw7QaEL84A2OeZoCD3jNYj3o6HOhQgkmtZ/sv7e8TR32BLOrwy5Bmn600HbfEcD4AgL3Bak7LQHHJbtUaUOprxgdN71DtDtY/b5Bz3JIejkuCxnTssdLxqUnDhWCJg2I9qezy8h2rmDbLz3ggYnYfEBsoiE6bdqba+z3OIx0lK7IN3hAxmZ+Znizsi14i/oE+lum3bf9QMzPeVk3o7EDOwbKEKAPT3m1QhtwLh8nrKBiENV2WlMDATEyz35N/5f6UCVPHc2W98k+lAREnjPs= dimidrol@netology
            EOT
        }
      + name                      = "vm-prod-2"
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
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance-2["3"] will be created
  + resource "yandex_compute_instance" "instance-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-3.netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTb8Ly3Uul8v5U/y3/vI7vB3oFhI3tMj3U5U+/nqyN1s1kGN46Bzx8CDR80ddHMud7jM9ya/OHpxVVCElp9i/40LPAZMNq6nIGiWhS0pfl950ky+VWtor3XJfygdRfi/h+Lp8mrXOGIauXgOKgd5b/IUQtUieb2z+1DcV8wl4x7n8Yw84GX5U/Wfa9r450fr39H+LPV35HdVKKD/KEJ+5xwD0qmtDD1sQKQMjgLe//zbMDw7QaEL84A2OeZoCD3jNYj3o6HOhQgkmtZ/sv7e8TR32BLOrwy5Bmn600HbfEcD4AgL3Bak7LQHHJbtUaUOprxgdN71DtDtY/b5Bz3JIejkuCxnTssdLxqUnDhWCJg2I9qezy8h2rmDbLz3ggYnYfEBsoiE6bdqba+z3OIx0lK7IN3hAxmZ+Znizsi14i/oE+lum3bf9QMzPeVk3o7EDOwbKEKAPT3m1QhtwLh8nrKBiENV2WlMDATEyz35N/5f6UCVPHc2W98k+lAREnjPs= dimidrol@netology
            EOT
        }
      + name                      = "vm-prod-3"
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
              + size        = 30
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
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance-2["4"] will be created
  + resource "yandex_compute_instance" "instance-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-prod-4.netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTb8Ly3Uul8v5U/y3/vI7vB3oFhI3tMj3U5U+/nqyN1s1kGN46Bzx8CDR80ddHMud7jM9ya/OHpxVVCElp9i/40LPAZMNq6nIGiWhS0pfl950ky+VWtor3XJfygdRfi/h+Lp8mrXOGIauXgOKgd5b/IUQtUieb2z+1DcV8wl4x7n8Yw84GX5U/Wfa9r450fr39H+LPV35HdVKKD/KEJ+5xwD0qmtDD1sQKQMjgLe//zbMDw7QaEL84A2OeZoCD3jNYj3o6HOhQgkmtZ/sv7e8TR32BLOrwy5Bmn600HbfEcD4AgL3Bak7LQHHJbtUaUOprxgdN71DtDtY/b5Bz3JIejkuCxnTssdLxqUnDhWCJg2I9qezy8h2rmDbLz3ggYnYfEBsoiE6bdqba+z3OIx0lK7IN3hAxmZ+Znizsi14i/oE+lum3bf9QMzPeVk3o7EDOwbKEKAPT3m1QhtwLh8nrKBiENV2WlMDATEyz35N/5f6UCVPHc2W98k+lAREnjPs= dimidrol@netology
            EOT
        }
      + name                      = "vm-prod-4"
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
              + size        = 30
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
          + cores         = 4
          + memory        = 4
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

Plan: 6 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
