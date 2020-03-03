provider "google" {
  project = "proelbtn"
}

locals {
  prefix = "locust-test"
  machine_type = "n1-standard-2"
  master_region = "asia-northeast1"
  slave_regions = [
    "asia-northeast1",
    "asia-northeast2"
  ]
  image = "ubuntu-os-cloud/ubuntu-1804-lts"
}

resource "google_compute_network" "network" {
  name = local.prefix
  auto_create_subnetworks = true
  routing_mode = "GLOBAL"
}

resource "google_compute_firewall" "firewall-for-external" {
  name = "${local.prefix}-external"
  network = google_compute_network.network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  target_tags = [local.prefix]
}

resource "google_compute_firewall" "firewall-for-locust" {
  name = "${local.prefix}-locust"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports = ["5557"]
  }

  source_tags = [local.prefix]
  target_tags = [local.prefix]
}

resource "google_compute_instance" "master" {
  name = "${local.prefix}-master-${local.master_region}"
  machine_type = local.machine_type
  zone = "${local.master_region}-a"

  tags = [local.prefix]

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = google_compute_network.network.name
    access_config {
    }
  }
}

resource "google_compute_instance" "slaves" {
  for_each = toset(local.slave_regions)

  name = "${local.prefix}-slave-${each.value}"
  machine_type = local.machine_type
  zone = "${each.value}-a"

  tags = [local.prefix]

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  network_interface {
    network = google_compute_network.network.name
    access_config {
    }
  }
}

output "master" {
  value = {
    name = google_compute_instance.master.name
    zone = google_compute_instance.master.zone
    nat_ip = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
    network_ip = google_compute_instance.master.network_interface.0.network_ip
  }
}

output "slaves" {
  value = [
    for instance in google_compute_instance.slaves:
      {
        name = instance.name
        zone = instance.zone
        nat_ip = instance.network_interface.0.access_config.0.nat_ip
        network_ip = instance.network_interface.0.network_ip
      }
  ]
}
