data "azurerm_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "canary" {
  name                = "${var.aks_cluster_name}-canary-law"
  resource_group_name = var.resource_group_name
}

resource "azuread_application" "canary_gha" {
  display_name = "${var.aks_cluster_name}-canary-gha"
}

resource "azuread_service_principal" "canary_gha" {
  client_id = azuread_application.canary_gha.client_id
}

resource "azuread_application_federated_identity_credential" "canary_gha_production" {
  application_id = azuread_application.canary_gha.id
  display_name   = "github-actions-canary-production"
  description    = "GitHub Actions production environment, canary release workflow"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:environment:production"
}

resource "azurerm_role_assignment" "canary_gha_aks_user" {
  principal_id                     = azuread_service_principal.canary_gha.object_id
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  scope                            = data.azurerm_kubernetes_cluster.aks.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "canary_gha_log_analytics_reader" {
  principal_id                     = azuread_service_principal.canary_gha.object_id
  role_definition_name             = "Log Analytics Reader"
  scope                            = data.azurerm_log_analytics_workspace.canary.id
  skip_service_principal_aad_check = true
}
