include {
  path = find_in_parent_folders()
}

locals {
  env = "stg"
}

terraform {
  source = "../../modules/mysql-flexible-server"
}

inputs = {
  environment         = local.env
  resource_group_name = "yourproject-${local.env}-other-RG"
  server_name         = "yourproject-${local.env}-mysql-server"
  administrator_login = "mysqluser"
  sku_name            = "B_Standard_B2s"
  zone                = "1"

  # 防火墙规则（以 map 形式传入）
  firewall_rules = {
    bastion = {
      name             = "bastion"
      start_ip_address = "20.37.96.145"
      end_ip_address   = "20.37.96.145"
    }
  }

  tags = {
    Custom_MySQLDB_Deprecation = "Acknowledged"
  }
}
