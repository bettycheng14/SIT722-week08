output "canary_workflow_client_id" {
  description = "Client ID of the managed identity used by the canary workflow"
  value       = azurerm_user_assigned_identity.canary_gha.client_id
}

output "canary_workflow_tenant_id" {
  description = "Azure AD tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "canary_workflow_subscription_id" {
  description = "Azure subscription ID"
  value       = data.azurerm_client_config.current.subscription_id
}
