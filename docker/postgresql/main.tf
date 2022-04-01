terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.15.0"
    }
  }
}

provider "postgresql" {
  host     = "localhost"
  port     = 5432
  database = "postgres"
  username = "postgres"
  password = "4y7sV96vA9wv46VR"
  #sslmode         = "require"
  sslmode         = "disable"
  connect_timeout = 15
}


resource "postgresql_role" "my_role" {

  for_each = var.databases_map
  name     = each.value.username
  password = each.value.password
  login    = true
}


resource "postgresql_database" "my_db" {

  for_each          = var.databases_map
  name              = each.value.db_name
  owner             = each.value.username
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}