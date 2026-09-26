data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "canary" {
  name                = "${var.aks_cluster_name}-canary-law"
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "canary_gha" {
  name                = "${var.aks_cluster_name}-canary-gha"
  resource_group_name = var.resource_group_name
  location            = data.azurerm_kubernetes_cluster.aks.location
}

resource "azurerm_federated_identity_credential" "canary_gha_production" {
  name                      = "github-actions-canary-production"
  user_assigned_identity_id = azurerm_user_assigned_identity.canary_gha.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_repository}:environment:production"
}

resource "azurerm_role_assignment" "canary_gha_aks_user" {
  principal_id                     = azurerm_user_assigned_identity.canary_gha.principal_id
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  scope                            = data.azurerm_kubernetes_cluster.aks.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "canary_gha_log_analytics_reader" {
  principal_id                     = azurerm_user_assigned_identity.canary_gha.principal_id
  role_definition_name             = "Log Analytics Reader"
  scope                            = data.azurerm_log_analytics_workspace.canary.id
  skip_service_principal_aad_check = true
}
