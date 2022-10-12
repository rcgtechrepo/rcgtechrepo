resource "az_vpc" "example" {
  cidr_block = "10.1.0.0/16"
}

resource "az_subnet" "example" {
  vpc_id = az_vpc.example.id

  availability_zone = "us-west-2b"
  cidr_block        = cidrsubnet(az_vpc.example.cidr_block, 4, 1)
}

module "network" {
  source = ".../advanced/modules/az-network"

  base_cidr_block = "10.0.0.0/8"
}

module "consul_cluster" {
  source = "../advanced/modules/az-sql-cluster"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
}

locals {
  db_server = "${split(".", var.db_server_fqdn)}"
}

resource "azurerm_sql_database" "db" {
  name                             = "${var.db_name}"
  location                         = "${var.location}"
  resource_group_name              = "${var.resource_group}"
  server_name                      = "${local.db_server[0]}"
  edition                          = "${var.db_edition}"
  collation                        = "${var.collation}"
  requested_service_objective_name = "${var.service_objective_name}"
  create_mode                      = "Default"

  provisioner "local-exec" {
    command = "sqlcmd -U ${var.sql_admin_username} -P ${var.sql_admin_password} -S ${var.db_server_fqdn} -d ${var.db_name} -i ${var.init_script_file} -o ${var.log_file}"
  }
}
