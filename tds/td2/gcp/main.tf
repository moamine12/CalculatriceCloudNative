terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project     = "mon_td_1"
  region      = "europe-west9"
}


resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}


resource "google_compute_instance" "my_vm" {
count=3  
name         = "my-vm-${count.index+1}"
  machine_type = "n2-standard-2"
  zone         = "europe-west9-a"  # Zone cohérente avec la région

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {}  # pour avoir une IP publique
  }
}


resource "google_sql_database_instance" "my_sql_database"{
  name="my-sql-database"
  database_version="MYSQL_8_0"
  region="europe-west9"
  settings{
    tier="db-g1-small"
  }
}


resource "google_dns_managed_zone" "ma_zone"{
  name="ma-zone"
  dns_name="amine.com."
}
resource "google_dns_record_set" "domaine"{
  name="domaine.${google_dns_managed_zone.ma_zone.dns_name}"
  type="A"
  ttl="300"
  managed_zone=google_dns_managed_zone.ma_zone.name
  rrdatas      = [google_compute_instance.my_vm1.network_interface[0].access_config[0].nat_ip]
}
lorsque on a rajouté count et tt on doit changer cette derniere ligne par la ligne suivante : 


rrdatas = [for i in google_compute_instance.my_vm : i.network_interface[0].access_config[0].nat_ip]



