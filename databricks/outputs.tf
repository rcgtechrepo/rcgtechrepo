output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  value = azurerm_databricks_workspace.example.url
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}