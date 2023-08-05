resource "azurerm_resource_group" "example" {
  name     = "RCG_Databricks"
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

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "fedex_PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  #name     = random_pet.rg_name.id
  #name	    = azurerm_resource_group.rg.id
  #name     = "fedex_rg_00001"
  name      = var.ENV_NAME
  
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "fedex_NetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "fedex_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_public_ip.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}
