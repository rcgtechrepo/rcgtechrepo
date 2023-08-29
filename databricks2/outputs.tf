
output "public_ip_address" {
  value = azurerm_databricks_workspace.example.workspace_url
}

/*output "databricks_token" {
  value     = databricks_token.pat.token_value
  sensitive = true
}*/

  