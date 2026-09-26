resource "azurerm_log_analytics_workspace" "canary" {
  name                = "${var.aks_cluster_name}-canary-law"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}
