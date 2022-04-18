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

# Create Secret Vault
resource "vault_generic_secret" "new_secrets" {
  for_each = var.databases_map
  path     = each.value.vault_secret_path

  data_json = <<EOT
{
  "dbusername": "${each.value.username}",
  "dbpassword": "${random_password.password[each.key].result}"
}
EOT
}

# Create Databases
resource "postgresql_database" "create_postgresql_db" {
  for_each          = var.databases_map
  name              = each.value.db_name
  owner             = each.value.username
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true

  depends_on = [
    postgresql_role.create_postgresql_role,
  ]
}