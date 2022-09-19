terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-s3"
    region     = "ru-central1-a"
    key        = "terraform.tfstate"
    access_key = "XXXXXXXXXXXXXXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

    skip_region_validation      = true
    skip_credentials_validation = true
 }

  required_version = ">= 0.78"
}

provider yandex {
  service_account_key_file = "key.json"
  cloud_id                 = "b1gb43cj4e37kp6cb04i"
  folder_id                = "b1gb4me0dlrtq7d9gg49"
  zone                     = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  network_id     = resource.yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
}

resource "yandex_compute_instance" "instance-1" {
  count    = local.instance_count[terraform.workspace]
  name        = "vm-${terraform.workspace}-${count.index+1}"
  hostname    = "vm-${terraform.workspace}-${count.index+1}.netology.local"
  platform_id = "standard-v1"

  resources {
    cores         = local.instance_cores[terraform.workspace]
    memory        = local.instance_memory[terraform.workspace]
 }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
    ipv6      = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_compute_instance" "instance-2" {
  for_each = local.virtual_machines[terraform.workspace]
  name     = "vm-${terraform.workspace}-${each.key}"
  hostname = "vm-${terraform.workspace}-${each.key}.netology.local"

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = "30"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
    ipv6      = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  instance_cores = {
    stage = 2
    prod  = 4
  }

  instance_count = {
    stage = 1
    prod  = 2
  }

  instance_memory = {
    stage = 2
    prod  = 4
  }

  virtual_machines = {
    stage = {
      "2" = { cores = "2", memory = "2" }
    }
    prod = {
      "3" = { cores = "4", memory = "4" },
      "4" = { cores = "4", memory = "4" }
    }
  }
}
