module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "5.7.0-preview0"

  providers = {
    azurerm.vhub = azurerm.vhub
  }

  global_settings = var.global_settings
  resource_groups = var.resource_groups
  keyvaults       = var.keyvaults
  # logged_user_objectId = var.logged_user_objectId ## use only if CAF version < 5.7.0

  compute = {
    aks_clusters = var.aks_clusters
  }

  networking = {
    public_ip_addresses = var.public_ip_addresses
    vnets               = var.vnets
  }

  role_mapping = {
    built_in_role_mapping = {
      aks_clusters = {
        cluster_dev1 = {
          "Azure Kubernetes Service RBAC Cluster Admin" = {
            object_ids = {
              keys = [ data.azurerm_client_config.current.object_id ]
            }
          }
        }
      }
    }
  }
}
