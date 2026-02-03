Le plan Terraform montre les actions à effectuer (créations uniquement).

Actions prévues :
Ressources réseau : VPC, Load Balancers, IP
Base de données : PostgreSQL pour dev et prod
Cluster Kubernetes : Cluster + Pool de nœuds
Registre de conteneurs : Namespace privé
Voici un extrait complet du résultat de la commande terraform plan :


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # scaleway_domain_record.dns["dev"] will be created
  + resource "scaleway_domain_record" "dns" {
      + data       = (known after apply)
      + dns_zone   = "polytech-dijon.kiowy.net"
      + fqdn       = (known after apply)
      + id         = (known after apply)
      + name       = "calculatrice-dev-namouchi_mohamed_amine-bazzi_taher-faniry_andriamasinoro"
      + priority   = (known after apply)
      + project_id = (known after apply)
      + root_zone  = (known after apply)
      + ttl        = 3600
      + type       = "A"
    }

  # scaleway_domain_record.dns["prod"] will be created
  + resource "scaleway_domain_record" "dns" {
      + data       = (known after apply)
      + dns_zone   = "polytech-dijon.kiowy.net"
      + fqdn       = (known after apply)
      + id         = (known after apply)
      + name       = "calculatrice-namouchi_mohamed_amine-bazzi_taher-faniry_andriamasinoro"
      + priority   = (known after apply)
      + project_id = (known after apply)
      + root_zone  = (known after apply)
      + ttl        = 3600
      + type       = "A"
    }

  # scaleway_k8s_cluster.cluster will be created
  + resource "scaleway_k8s_cluster" "cluster" {
      + apiserver_url               = (known after apply)
      + cni                         = "cilium"
      + created_at                  = (known after apply)
      + delete_additional_resources = false
      + id                          = (known after apply)
      + kubeconfig                  = (sensitive value)
      + name                        = "calculatrice-cluster"
      + organization_id             = (known after apply)
      + pod_cidr                    = (known after apply)
      + private_network_id          = (known after apply)
      + project_id                  = (known after apply)
      + service_cidr                = (known after apply)
      + service_dns_ip              = (known after apply)
      + status                      = (known after apply)
      + type                        = (known after apply)
      + updated_at                  = (known after apply)
      + upgrade_available           = (known after apply)
      + version                     = "1.29.1"
      + wildcard_dns                = (known after apply)

      + auto_upgrade (known after apply)

      + autoscaler_config (known after apply)

      + open_id_connect_config (known after apply)
    }

  # scaleway_k8s_pool.pool will be created
  + resource "scaleway_k8s_pool" "pool" {
      + autohealing            = false
      + autoscaling            = false
      + cluster_id             = (known after apply)
      + container_runtime      = "containerd"
      + created_at             = (known after apply)
      + current_size           = (known after apply)
      + id                     = (known after apply)
      + max_size               = (known after apply)
      + min_size               = 1
      + name                   = "calculatrice-pool"
      + node_type              = "DEV1-M"
      + nodes                  = (known after apply)
      + public_ip_disabled     = false
      + root_volume_size_in_gb = (known after apply)
      + root_volume_type       = (known after apply)
      + security_group_id      = (known after apply)
      + size                   = 2
      + status                 = (known after apply)
      + updated_at             = (known after apply)
      + version                = (known after apply)
      + wait_for_pool_ready    = true

      + upgrade_policy (known after apply)
    }

  # scaleway_lb.loadbalancer["dev"] will be created
  + resource "scaleway_lb" "loadbalancer" {
      + external_private_networks = false
      + id                        = (known after apply)
      + ip_address                = (known after apply)
      + ip_id                     = (known after apply)
      + ip_ids                    = (known after apply)
      + ipv6_address              = (known after apply)
      + name                      = "lb-dev"
      + organization_id           = (known after apply)
      + private_ips               = (known after apply)
      + project_id                = (known after apply)
      + region                    = (known after apply)
      + ssl_compatibility_level   = "ssl_compatibility_level_intermediate"
      + type                      = "lb-bc1-s"

      + private_network (known after apply)
    }

  # scaleway_lb.loadbalancer["prod"] will be created
  + resource "scaleway_lb" "loadbalancer" {
      + external_private_networks = false
      + id                        = (known after apply)
      + ip_address                = (known after apply)
      + ip_id                     = (known after apply)
      + ip_ids                    = (known after apply)
      + ipv6_address              = (known after apply)
      + name                      = "lb-prod"
      + organization_id           = (known after apply)
      + private_ips               = (known after apply)
      + project_id                = (known after apply)
      + region                    = (known after apply)
      + ssl_compatibility_level   = "ssl_compatibility_level_intermediate"
      + type                      = "lb-bc1-s"

      + private_network (known after apply)
    }

  # scaleway_lb_ip.lb_ip["dev"] will be created
  + resource "scaleway_lb_ip" "lb_ip" {
      + id              = (known after apply)
      + ip_address      = (known after apply)
      + is_ipv6         = false
      + lb_id           = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + region          = (known after apply)
      + reverse         = (known after apply)
    }

  # scaleway_lb_ip.lb_ip["prod"] will be created
  + resource "scaleway_lb_ip" "lb_ip" {
      + id              = (known after apply)
      + ip_address      = (known after apply)
      + is_ipv6         = false
      + lb_id           = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + region          = (known after apply)
      + reverse         = (known after apply)
    }

  # scaleway_redis_cluster.db["dev"] will be created
  + resource "scaleway_redis_cluster" "db" {
      + certificate  = (known after apply)
      + cluster_size = 1
      + created_at   = (known after apply)
      + id           = (known after apply)
      + name         = "db-dev"
      + node_type    = "RED1-MICRO"
      + password     = (sensitive value)
      + project_id   = (known after apply)
      + updated_at   = (known after apply)
      + user_name    = "admin"
      + version      = "7.0"

      + private_ips (known after apply)

      + public_network (known after apply)
    }

  # scaleway_redis_cluster.db["prod"] will be created
  + resource "scaleway_redis_cluster" "db" {
      + certificate  = (known after apply)
      + cluster_size = 3
      + created_at   = (known after apply)
      + id           = (known after apply)
      + name         = "db-prod"
      + node_type    = "RED1-S"
      + password     = (sensitive value)
      + project_id   = (known after apply)
      + updated_at   = (known after apply)
      + user_name    = "admin"
      + version      = "7.0"

      + private_ips (known after apply)

      + public_network (known after apply)
    }

  # scaleway_registry_namespace.container_registry will be created
  + resource "scaleway_registry_namespace" "container_registry" {
      + description     = "Registry pour les conteneurs de l'application Calculatrice Native"
      + endpoint        = (known after apply)
      + id              = (known after apply)
      + is_public       = false
      + name            = "calculatrice-native-container-registry"
      + organization_id = (known after apply)
      + project_id      = (known after apply)
    }

  # scaleway_vpc_private_network.pn will be created
  + resource "scaleway_vpc_private_network" "pn" {
      + created_at                       = (known after apply)
      + enable_default_route_propagation = (known after apply)
      + id                               = (known after apply)
      + is_regional                      = (known after apply)
      + name                             = (known after apply)
      + organization_id                  = (known after apply)
      + project_id                       = (known after apply)
      + updated_at                       = (known after apply)
      + vpc_id                           = (known after apply)
      + zone                             = (known after apply)

      + ipv4_subnet (known after apply)

      + ipv6_subnets (known after apply)
    }

Plan: 12 to add, 0 to change, 0 to destroy.