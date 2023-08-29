terraform {
  required_version = ">=0.12"

  required_providers {
   databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = "https://adb-6829372696756496.16.azuredatabricks.net"
  username = "eric.perler@rcggs.com"
  password = "Cdi6954c"
}
