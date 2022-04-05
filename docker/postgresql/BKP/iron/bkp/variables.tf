variable "append_secret" { 
    type = bool
    default = true
    description = "Allow to append the new secrets to existing one"
}
variable "secret_path" {
    type        = string
    description = "Vault path for secret storage"
}

variable "secrets" {
  type = map(string)
  description = "Define Key Vault secrets"
}
