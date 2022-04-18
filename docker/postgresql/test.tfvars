# PATH del secret con los datos del login del RDS
secret_path        = "secret/rds-lab"
db_port            = 5432
db_host            = "localhost"
db_sslmode         = "disable"
db_connect_timeout = 15


# Mapa con bases a crear.
databases_map = {
  0 = {
    db_name           = "db10"
    vault_secret_path = "secret/database/db10"
    username          = "user_db10"

  }
  1 = {
    db_name           = "db11"
    vault_secret_path = "secret/database/db11"
    username          = "user_db11"

  }
  2 = {
    db_name           = "db12"
    vault_secret_path = "secret/database/db12"
    username          = "user_db12"

  }
}
