variable "databases_map" {
  type = map(object({
    db_name  = string
    username = string
    password = string
  }))
  description = "Maps databases for RDS Cluster"
}
