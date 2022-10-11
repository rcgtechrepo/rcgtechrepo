resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  #name     = random_pet.rg_name.id
  #name	    = azurerm_resource_group.rg.id
  #name     = "fedex_rg_00001"
  name      = var.ENV_NAME
}






resource "azurerm_storage_account" "example" {
  name                     = "examplesa"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "example" {
  name                         = "rcgmssqlserver"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  version                      = "12.0"
  administrator_login          = "eric.perler@rcggs.com"
  administrator_login_password = "Cdi6954c"

  tags = {
    environment = "production"
  }
}

resource "azurerm_sql_database" "example" {
  name                = "myexamplesqldatabase"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.example.name

  }
