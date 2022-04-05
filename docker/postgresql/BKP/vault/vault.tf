terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.4.1"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token = "hvs.S14CVWP8BEqm2c4l8aX08ITP"
}


data "vault_policy_document" "list_secrets" {
  rule {
    path         = "secret/*"
    capabilities = ["list"]
    description  = "allow List on secrets under everyone/"
  }
}

resource "vault_policy" "list_secrets" {
  name   = "example_policy"
  policy = data.vault_policy_document.list_secrets.hcl
}


data "vault_generic_secret" "prueba" {
  path = "secret/prueba"
}


resource "vault_consul_secret_backend" "test" {
  path        = "consul"
  description = "Manages the Consul backend"

  address = "127.0.0.1:8200"
  token   = "hvs.S14CVWP8BEqm2c4l8aX08ITP"
}


output "rundeck" {
  sensitive = true
  value = data.vault_generic_secret.prueba.data
}


output "list" {
  value = data.vault_policy_document.list_secrets
}


resource "vault_mount" "test" {
  path        = "transit"
  type        = "transit"
  description = "This is an example mount"
}

resource "vault_transit_secret_backend_key" "test" {
  backend = "vault_mount.test.path"
  name    = "test"
}

data "vault_transit_encrypt" "test" {
  backend   = vault_mount.test.path
  key       = vault_transit_secret_backend_key.test.name
  plaintext = "foobar"
}