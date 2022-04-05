data "vault_generic_secret" "secret" {
  path = var.secret_path
}

locals {
    original_secret = {for k, v in data.vault_generic_secret.secret.data : k => v}
}

resource "vault_generic_secret" "secret_append" {
    count = var.append_secret ? 1 : 0 
    path = var.secret_path
    data_json = jsonencode(merge(local.original_secret,var.secrets))
}

resource "vault_generic_secret" "secret_new" {
    count = var.append_secret ? 0 : 1
    path = var.secret_path
    data_json = jsonencode(var.secrets)
}


data "vault_generic_secret" "prueba" {
  path = "secret/prueba"
}

output "username" {
  sensitive = true
  value = data.vault_generic_secret.prueba.data.username
}

output "password" {
  sensitive = true
  value = data.vault_generic_secret.prueba.data.password
}
