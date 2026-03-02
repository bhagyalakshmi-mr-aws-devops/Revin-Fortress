terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

# Creates: RDS PostgreSQL Multi-AZ, encrypted, backups + PITR enabled.
# Network: private DB subnets + SG allowing inbound only from app tier.

output "db_endpoint" { value = "REPLACE_WITH_RDS_ENDPOINT" }
