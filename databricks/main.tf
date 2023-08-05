resource "azurerm_resource_group" "example" {
  name     = "RCG Databricks"
  location = "East US"
}

resource "azurerm_databricks_workspace" "example" {
  #name                = "databrickstest"
  name                 =  var.ENV_NAME
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"

  tags = {
    Environment = "Production"
  }
}

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