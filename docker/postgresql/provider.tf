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
  address = "http://127.0.0.1:8200"
  token   = "hvs.BhjLZGCbfQ6O7w2OzbvpBGbJ"
}




