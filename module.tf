module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "5.7.0-preview0"

  providers = {
    azurerm.vhub = azurerm.vhub
  }

  global_settings = var.global_settings
  resource_groups = var.resource_groups
  keyvaults       = var.keyvaults
  logged_user_objectId = var.logged_user_objectId

  compute = {
    aks_clusters = var.aks_clusters
  }

  networking = {
    public_ip_addresses = var.public_ip_addresses
    vnets               = var.vnets
  }
}
