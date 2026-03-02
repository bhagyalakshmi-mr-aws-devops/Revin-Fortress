# Infrastructure as Code – AWS Platform

## Objective

Provision and manage infrastructure in a consistent, repeatable, and auditable
manner using Terraform.

---

## Design Principles

- Infrastructure defined declaratively
- Modular design for reuse
- Environment isolation via separate state
- Least-privilege access controls

---

## Modules Overview

### VPC
- Public subnets for load balancers
- Private subnets for application workloads
- Isolated subnets for databases
- NAT gateways for outbound access

### EKS
- Managed Kubernetes control plane
- Node groups distributed across AZs
- Private networking configuration

### RDS
- PostgreSQL Multi-AZ deployment
- Automated backups and PITR
- Encrypted storage

### IAM
- Role-based access control
- Separation of human and workload permissions
- Secure credential delivery to workloads

---

## Environment Stacks

Each environment (dev, staging, prod) has:
- Independent Terraform state
- Independent infrastructure resources
- Independent security boundaries