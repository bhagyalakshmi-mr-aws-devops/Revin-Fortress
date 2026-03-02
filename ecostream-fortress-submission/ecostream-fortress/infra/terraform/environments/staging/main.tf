terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

provider "aws" { region = var.region }

locals {
  name = "ecostream-staging"
  tags = {
    Project     = "ecostream"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"
}

module "eks" {
  source = "../../modules/eks"
}

module "rds" {
  source = "../../modules/rds"
}

output "cluster_name" { value = module.eks.cluster_name }
output "db_endpoint"  { value = module.rds.db_endpoint }
