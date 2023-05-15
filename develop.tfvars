# logged_user_objectId = "$(az ad signed-in-user show --query id -o tsv)" ## Tylko jeśli uzyto modułu CAF < 5.7.0

global_settings = {
  default_region = "region1"
  prefix = "develop"
  regions = {
    region1 = "westeurope"
  }
}

resource_groups = {
  az-lx-rg-aks = {
    name   = "az-lx-rg-aks"
    region = "region1"
    tags = {
      Environment = "develop"
      Application_Name = "aks_caf_develop"
      Devops = "mariusz.brzezik@luxmed.pl"
    }
  }
}

aks_clusters = {
  cluster_dev1 = {
    name               = "akscluster-dev1-001"
    resource_group_key = "az-lx-rg-aks"
    os_type            = "Linux"

    identity = {
      type = "SystemAssigned"
    }

    vnet_key = "spoke_aks_dev1"

    network_profile = {
      network_plugin    = "azure"
      load_balancer_sku = "standard"
    }

    # enable_rbac = true
    role_based_access_control = {
      enabled = true
      azure_active_directory = {
        managed = true
      }
    }

    addon_profile = {
      oms_agent = {
        enabled           = true
        log_analytics_key = "central_logs_region1"
      }
    }

    load_balancer_profile = {
      # Only one option can be set
      managed_outbound_ip_count = 1
    }

    default_node_pool = {
      name    = "sharedsvc"
      vm_size = "Standard_B2ms"
      subnet_key = "aks_nodepool_system"
      subnet = {
        key = "aks_nodepool_system"
      }
      enabled_auto_scaling  = false
      enable_node_public_ip = false
      max_pods              = 30
      node_count            = 1
      os_disk_size_gb       = 512
      tags = {
        "project" = "system services"
      }
    }

    node_resource_group_name = "aks-nodes-dev1"

    addon_profile = {
      azure_keyvault_secrets_provider = {
        secret_rotation_enabled  = true
        secret_rotation_interval = "2m"
      }
    }
  }
}

vnets = {
spoke_aks_dev1 = {
    resource_group_key = "az-lx-rg-aks"
    region             = "region1"
    ddos_services_key  = "ddos-plan"    
    vnet = {
      name          = "aks-develop"
      address_space = ["10.63.48.0/22"]
    }
    subnets = {
      aks_nodepool_system = {
        name    = "nodepool_sys"
        cidr    = ["10.63.48.0/24"]
        nsg_key = "azure_kubernetes_cluster_nsg"
      }
      aks_nodepool_user1 = {
        name    = "nodepool_user1s"
        cidr    = ["10.63.49.0/24"]
        nsg_key = "azure_kubernetes_cluster_nsg"
      }
      aks_nodepool_user2 = {
        name    = "nodepool_user2s"
        cidr    = ["10.63.50.0/24"]
        nsg_key = "azure_kubernetes_cluster_nsg"
      }
      AzureBastionSubnet = {
        name    = "AzureBastionSubnets" #Must be called AzureBastionSubnet
        cidr    = ["10.63.51.64/27"]
        nsg_key = "azure_bastion_nsg"
      }
      private_endpoints = {
        name    = "private_endpoints"
        cidr    = ["10.63.51.0/27"]
        enforce_private_link_endpoint_network_policies = true
      }
      jumpbox = {
        name    = "jumpbox-develop"
        cidr    = ["10.63.51.128/27"]
        nsg_key = "azure_bastion_nsg"
      }
    }

  }
}
