# foundation/main.tf
terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

# Variables locales
locals {
  # Formater les noms pour DNS
  formatted_name1 = lower(replace(var.nombinome1, " ", "_"))
  formatted_name2 = lower(replace(var.nombinome2, " ", "_"))
  formatted_name3 = lower(replace(var.nombinome3, " ", "_"))
  
  environments = ["dev", "prod"]
  
  environment_specs = {
    dev = {
      db_name         = "db-dev"
      lb_name         = "lb-dev"
      # Noms formatés pour les 3 personnes
      dns_subdomain   = "calculatrice-dev-${local.formatted_name1}-${local.formatted_name2}-${local.formatted_name3}"
    }
    prod = {
      db_name         = "db-prod"
      lb_name         = "lb-prod"
      # Noms formatés pour les 3 personnes
      dns_subdomain   = "calculatrice-${local.formatted_name1}-${local.formatted_name2}-${local.formatted_name3}"
    }
  }
}

# Registry
resource "scaleway_registry_namespace" "container_registry" {
  name        = "calculatrice-native-container-registry"
  is_public   = false
  description = "Registry pour les conteneurs de l'application Calculatrice Native"
}

# Cluster K8s
resource "scaleway_vpc_private_network" "pn" {}

resource "scaleway_k8s_cluster" "cluster" {
  name    = "calculatrice-cluster"
  version = "1.29.1"
  cni     = "cilium"
  private_network_id = scaleway_vpc_private_network.pn.id
}

resource "scaleway_k8s_pool" "pool" {
  cluster_id = scaleway_k8s_cluster.cluster.id
  name       = "calculatrice-pool"
  node_type  = "DEV1-M"
  size       = 2
}

# Bases de données (Redis)
resource "scaleway_redis_cluster" "db" {
  for_each      = local.environment_specs
  name          = each.value.db_name
  version       = "7.0"
  node_type     = each.key == "dev" ? "RED1-MICRO" : "RED1-S"
  cluster_size  = each.key == "dev" ? 1 : 3
  user_name     = "admin"
  password      = "SecurePassword123!"  # À mettre dans des variables!
}

# LoadBalancers
resource "scaleway_lb_ip" "lb_ip" {
  for_each = local.environment_specs
}

resource "scaleway_lb" "loadbalancer" {
  for_each = local.environment_specs
  name     = each.value.lb_name
  type     = "lb-bc1-s"
  ip_id    = scaleway_lb_ip.lb_ip[each.key].id
}

# DNS
resource "scaleway_domain_record" "dns" {
  for_each = local.environment_specs
  
  dns_zone = "polytech-dijon.kiowy.net"
  name     = each.value.dns_subdomain
  type     = "A"
  data     = scaleway_lb_ip.lb_ip[each.key].ip_address
  ttl      = 3600
}

