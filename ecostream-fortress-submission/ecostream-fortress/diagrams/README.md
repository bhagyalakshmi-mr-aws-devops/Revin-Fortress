Open `Revin-Fortress-Architecture.drawio` in diagrams.net and export PNG/PDF.

# Revin Fortress
## Multi-Environment, Automated, Secure AWS Reference Architecture (EKS)

**Role:** DevOps Engineer (Foundations / Platform)  
**Assignment:** Production Infrastructure Modernization  
**Organization:** Revin Techno Solutions Pvt Ltd – TECHIN, IIT Palakkad  

## 1. Background & Problem Statement

EcoStream started with a rapid “move fast and break things” mindset.
The entire platform was deployed manually from a developer’s laptop into a single AWS production environment.

With projected growth from 5,000 to 500,000 users, the existing setup introduces critical risks:

- Development, testing, and production share the same environment
- Manual SSH-based deployments with no rollback
- Unmanaged database with no guaranteed recovery
- Credentials stored in `.env` files
- No observability or early-warning system

This repository presents a production-grade Software Factory that converts application code into a secure, scalable, and observable service.

## 2. High-Level Architecture

### Traffic Flow

Users → Route 53 → AWS WAF → Application Load Balancer (Public) → Amazon EKS (Private Subnets) → RDS PostgreSQL (Private, Multi-AZ)

### Design Principles

- Strong environment isolation
- No manual access to production
- Managed, resilient data layer
- Secrets never stored in code
- Automated deployment with rollback
- Built-in observability

### Architecture Diagram

diagrams/Revin-Fortress-Architecture.drawio  
(Exported as PNG/PDF using diagrams.net)

## 3. Environment Isolation Strategy

Each environment is deployed in a separate AWS account under AWS Organizations.

### Environments

- Development
- Staging
- Production

### Isolation Enforcement

- Separate AWS accounts
- Separate VPCs
- Separate EKS clusters
- Separate RDS instances
- Separate Secrets Manager entries
- Separate Terraform state files

This ensures Development can never impact Production.

## 4. Architecture Design (Detailed)

### Architecture Goals

- Eliminate human error in production
- Prevent environment cross-impact
- Ensure data durability and recoverability
- Secure secrets and network boundaries
- Enable automatic scaling
- Detect failures before customer impact

### Network Architecture

Each environment contains a dedicated VPC with:

Public Subnets:
- Application Load Balancer
- NAT Gateway

Private Application Subnets:
- Amazon EKS worker nodes
- Kubernetes pods

Private Database Subnets:
- Amazon RDS PostgreSQL

Security rules:
- ALB is the only public-facing component
- EKS nodes accept traffic only from ALB
- RDS accepts traffic only from application security groups
- No direct inbound access to compute or database resources

### Application Platform – Amazon EKS

Amazon EKS is used to run application workloads securely and at scale.

Key characteristics:
- Private EKS cluster
- Managed node groups across multiple Availability Zones
- No public IPs on worker nodes
- ALB Ingress Controller for traffic routing

Kubernetes workloads include:
- Deployments for applications
- Horizontal Pod Autoscaler (HPA)
- Cluster Autoscaler
- Kubernetes Jobs for database migrations and smoke tests

### Deployment Architecture (CI/CD)

Deployments are fully automated using CI/CD pipelines.

Pipeline flow:
- Code push to GitHub
- GitHub Actions triggers pipeline
- CI stage runs tests, scans, and builds images
- Images pushed to Amazon ECR
- CD deploys to Development and Staging
- Production deployment requires approval
- Kubernetes performs rolling updates

No SSH access is required or permitted.

### Data Layer Architecture

The data layer uses Amazon RDS PostgreSQL.

Features:
- Multi-AZ deployment
- Automated backups
- Encryption at rest
- Point-in-Time Recovery (PITR)

Schema changes are:
- Version controlled
- Executed as Kubernetes Jobs
- Applied before production traffic rollout
- Backward compatible

### Secrets & Identity Management

Secrets are managed using AWS Secrets Manager.

- Secrets injected at runtime
- IAM Roles for Service Accounts (IRSA)
- No credentials in repositories
- No `.env` files on servers
- Rotation-ready secrets

Human users have no administrative access to production systems.

### Observability Architecture

Observability is implemented using Amazon CloudWatch.

Signals collected:
- Application logs
- Infrastructure metrics
- Database metrics

Alerts trigger on:
- HTTP 5XX error spikes
- High latency
- Resource saturation
- Database storage thresholds

### High Availability & Disaster Recovery

High availability:
- Multi-AZ EKS and RDS
- Load balancing across Availability Zones

Disaster recovery:
- Automatic RDS failover
- PITR-based restoration
- Snapshot-based recovery if required

Targets:
- RPO: Minutes
- RTO: Minutes to under one hour

### Scalability Strategy

The platform scales automatically using:
- Horizontal Pod Autoscaler (HPA)
- Cluster Autoscaler
- ALB auto-scaling
- Database vertical scaling and read replicas

This supports rapid growth without manual intervention.

## 5. Repository Structure

- app – Hello World application
- infra/terraform – Infrastructure as Code
- k8s – Kubernetes manifests
- diagrams – Architecture diagrams
- runbook – Operational runbooks
- docs – Detailed explanations
- .github/workflows – CI/CD pipelines

## 6. Final Outcome

This architecture replaces a fragile, manually operated system with a secure, automated, production-ready platform.

It enforces isolation, protects data, eliminates human risk, enables observability, and scales confidently.
