data "vault_generic_secret" "prueba" {
  path = var.secret_path
}

output "username" {
  sensitive = true
  value     = data.vault_generic_secret.prueba.data.username
}


provider "postgresql" {
  host            = data.vault_generic_secret.prueba.data.host
  port            = 5432
  database        = data.vault_generic_secret.prueba.data.database
  username        = data.vault_generic_secret.prueba.data.username
  password        = data.vault_generic_secret.prueba.data.password
  sslmode         = "disable"
  connect_timeout = 15
}


resource "postgresql_role" "my_role" {

  for_each = var.databases_map
  name     = each.value.username
  password = each.value.password
  login    = true
}

resource "vault_generic_secret" "new_secrets" {
  for_each = var.databases_map
  path     = "secret/${each.value.db_name}"

  data_json = <<EOT
{
  "username":   "${each.value.username}",
  "password": "${each.value.password}"
}
EOT
}

resource "postgresql_database" "my_db" {

  for_each          = var.databases_map
  name              = each.value.db_name
  owner             = each.value.username
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true

  depends_on = [
    postgresql_role.my_role,
  ]
}