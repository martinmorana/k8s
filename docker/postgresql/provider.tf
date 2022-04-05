terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    version = "3.4.1" }

    postgresql = {
      source = "cyrilgdn/postgresql"
    version = "1.15.0" }
  }
}

provider "vault" {
  add_address_to_env = true
}




