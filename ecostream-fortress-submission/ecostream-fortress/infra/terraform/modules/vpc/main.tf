terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

# Creates: VPC, IGW, public/private/db subnets across AZs, NAT, route tables.
# Public: ALB
# Private: EKS nodes/pods
# DB: RDS

output "vpc_id"            { value = "REPLACE_WITH_VPC_ID" }
output "public_subnet_ids" { value = ["REPLACE_WITH_PUBLIC_SUBNET_ID"] }
output "private_subnet_ids"{ value = ["REPLACE_WITH_PRIVATE_SUBNET_ID"] }
output "db_subnet_ids"     { value = ["REPLACE_WITH_DB_SUBNET_ID"] }
