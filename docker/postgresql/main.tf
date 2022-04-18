# DS Hashicorp Vault
data "vault_generic_secret" "prueba" {
  path = var.secret_path
}

# Provider for connect to RDS Aurora
provider "postgresql" {
  host            = var.db_host
  port            = var.db_port
  database        = data.vault_generic_secret.prueba.data.database
  username        = data.vault_generic_secret.prueba.data.username
  password        = data.vault_generic_secret.prueba.data.password
  sslmode         = var.db_sslmode
  connect_timeout = var.db_connect_timeout
}

# Generate Random Password
resource "random_password" "password" {
  count            = length(var.databases_map)
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create PostgueSQL Role
resource "postgresql_role" "create_postgresql_role" {
  for_each = var.databases_map
  name     = each.value.username
  password = random_password.password[each.key].result
  login    = true
}

data "vault_generic_secret" "secret" {
  for_each = var.databases_map
  path     = each.value.vault_secret_path
}

# Create Secret Vault
resource "vault_generic_secret" "new_secrets" {

  for_each  = var.databases_map
  path      = data.vault_generic_secret.secret[each.key].path
  data_json = jsonencode(merge(data.vault_generic_secret.secret[each.key].data, { dbusername = "${each.value.username}", dbpassword = "${random_password.password[each.key].result}" }))
}


/* output "prueba" {
  value = data.vault_generic_secret.secre[0].data
} */

# Create Databases
resource "postgresql_database" "create_postgresql_db" {
  for_each          = var.databases_map
  
  name              = each.value.db_name
  owner             = each.value.username
  lc_collate        = "en_US.UTF-8"
  connection_limit  = -1
  allow_connections = true

  depends_on = [
    postgresql_role.create_postgresql_role,
  ]
}