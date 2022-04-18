variable "secret_path" {
  type        = string
  description = "Vault path for secret storage"
}

variable "db_host" {
  type        = string
  description = "Host name RDS"
}

variable "db_port" {
  type        = number
  description = "RDS Port"
}

variable "db_sslmode" {
  type        = string
  description = "SSL Mode PostgreSQL"
}

variable "db_connect_timeout" {
  type        = number
  description = "RDS Port"
}

variable "databases_map" {
  type = map(object({
    db_name           = string
    vault_secret_path = string
    username          = string
  }))
  description = "Maps databases for RDS Cluster"
}
