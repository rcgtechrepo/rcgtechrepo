output "public_ip_address" {
  value = azurerm_databricks_workspace.example.workspace_url
}