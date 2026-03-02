terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

# Creates: EKS control plane, managed node groups, cluster SGs, OIDC provider for IRSA.
# Recommended: private endpoint + restricted public access.

output "cluster_name"     { value = "REPLACE_WITH_CLUSTER_NAME" }
output "cluster_endpoint" { value = "REPLACE_WITH_CLUSTER_ENDPOINT" }
