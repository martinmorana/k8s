# PATH del secret con los datos del login del RDS
secret_path        = "secret/rds-lab"
db_port            = 5432
db_host            = "localhost"
db_sslmode         = "disable"
db_connect_timeout = 15


# Mapa con bases a crear.
databases_map = {
  db1 = {
    db_name           = "db1"
    vault_secret_path = "secret/database/db1"
    username          = "user_db1"
    password          = "pass_db1"
  }
  db2 = {
    db_name           = "db2"
    vault_secret_path = "secret/database/db2"
    username          = "user_db2"
    password          = "passw_db2"
  }
  db3 = {
    db_name           = "db3"
    vault_secret_path = "secret/database/db3"
    username          = "user_db3"
    password          = "passw_db3"
  }
  db4 = {
    db_name           = "db4"
    vault_secret_path = "secret/database/db4"
    username          = "user_db4"
    password          = "passw4"
  }
  db5 = {
    db_name           = "db5"
    vault_secret_path = "secret/database/db5"
    username          = "user_db5"
    password          = "passw5"
  }

}
