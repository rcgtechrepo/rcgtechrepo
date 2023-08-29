terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.11"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "databricks" {
    host = azurerm_databricks_workspace.example.workspace_url
}

resource "azurerm_resource_group" "example" {
  name     = "databricks_rg"
  location = "East US"
}

resource "azurerm_databricks_workspace" "example" {
  name                        = "DBW-ansuman"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  sku                         = "premium"
  managed_resource_group_name = "ansuman-DBW-managed-without-lb"

  public_network_access_enabled = true

 // custom_parameters {
  //  no_public_ip        = true
  //  public_subnet_name  = azurerm_subnet.public.name
//    virtual_network_id  = azurerm_virtual_network.example.id

   // public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
   // private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
 // }

  tags = {
    Environment = "Production"
    Pricing     = "Standard"
  }
}
data "databricks_node_type" "smallest" {
  local_disk = true
    depends_on = [
    azurerm_databricks_workspace.example
  ]
}
data "databricks_spark_version" "latest_lts" {
  long_term_support = false
    depends_on = [
    azurerm_databricks_workspace.example
  ]
}
resource "databricks_cluster" "dbcselfservice" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = "12.2.x-scala2.12" //data.databricks_spark_version.latest_lts.id
  node_type_id            = "Standard_F4" //data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 1
  }
  azure_attributes {
    availability       = "SPOT_AZURE"
    first_on_demand    = 1
    spot_bid_max_price = 100
  }
  depends_on = [
    azurerm_databricks_workspace.example
  ]
}
resource "databricks_group" "db-group" {
  display_name               = "adb-users-admin"
  allow_cluster_create       = true
  allow_instance_pool_create = true
  depends_on = [
    resource.azurerm_databricks_workspace.example
  ]
}

resource "databricks_user" "dbuser" {
  display_name     = "Rahul Sharma"
  user_name        = "example@contoso.com"
  workspace_access = true
  depends_on = [
    resource.azurerm_databricks_workspace.example
  ]
}
resource "databricks_group_member" "i-am-admin" {
  group_id  = databricks_group.db-group.id
  member_id = databricks_user.dbuser.id
  depends_on = [
    resource.azurerm_databricks_workspace.example
  ]
}
