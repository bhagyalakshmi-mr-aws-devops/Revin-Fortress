variable "name" {
  type        = string
  description = "RDS identifier/name"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for DB subnet group"
}

variable "db_username" {
  type        = string
  description = "DB master username"
}

variable "db_password" {
  type        = string
  description = "DB master password"
  sensitive   = true
}
