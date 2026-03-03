# EcoStream Fortress – Production Infrastructure Modernization (AWS + EKS)

## Overview

EcoStream’s initial production environment was created with a rapid development mindset,
resulting in a tightly coupled, manually operated infrastructure. With projected growth from
5,000 to 500,000 users and the onboarding of a major utility partner, the existing setup poses
significant operational and business risks.

This repository defines a production-ready **Software Factory** built on AWS, designed to
deliver secure, automated, scalable, and observable application deployments using Amazon EKS.

---

## Target Architecture Summary

### Traffic Flow
1. Users access the application through a public domain.
2. Amazon Route 53 resolves DNS to an Application Load Balancer.
3. AWS WAF protects the edge against common attacks and abuse.
4. The Application Load Balancer routes traffic to Kubernetes services via Ingress.
5. Application workloads run as pods inside Amazon EKS in private subnets.
6. Data is stored in Amazon RDS PostgreSQL deployed in private subnets with Multi-AZ enabled.

### Key Characteristics
- No direct SSH access to servers
- Private-by-default networking
- Fully automated deployments
- Managed, highly available database
- Continuous monitoring and alerting

---

## Environment Isolation Strategy

### Objective
Ensure development and testing activities can never impact production systems.

### Approach
- Separate environments: **Development**, **Staging**, and **Production**
- Each environment has:
  - Its own VPC
  - Its own EKS cluster
  - Its own database instance
  - Its own secrets and IAM permissions
- Terraform state is isolated per environment to prevent cross-environment changes.

Kubernetes overlays are used to customize deployment behavior per environment
(e.g., replica counts, image tags).

---

## Automated Deployment Pipeline (Assembly Line)

### CI/CD Flow
1. Developer commits code to the repository.
2. CI pipeline:
   - Builds a container image
   - Runs basic validation
   - Pushes the image to Amazon ECR
3. CD pipeline:
   - Deploys the image to the target environment using Kubernetes manifests
   - Uses health checks to verify readiness
   - Allows immediate rollback if issues are detected

### Deployment Safety
- Rolling updates with readiness and liveness probes
- Canary or blue-green deployment patterns can be applied
- Rollback is performed by reverting to a previous container image

This removes the need for SSH-based deployments and eliminates manual risk.

---

## Data Integrity and Schema Evolution

### Database Platform
- Amazon RDS PostgreSQL
- Multi-AZ enabled for high availability
- Automated backups and Point-in-Time Recovery (PITR)
- Encrypted storage

### Schema Changes
- Database schema changes are versioned
- Migrations are executed as Kubernetes Jobs prior to application rollout
- Backward-compatible migration patterns are followed to allow safe rollbacks

---

## Network Perimeter and Secrets Management

### Network Security
- Only the Application Load Balancer is publicly accessible
- EKS worker nodes and RDS instances are deployed in private subnets
- Security groups restrict database access to application workloads only

### Secrets Handling
- All sensitive values are stored in AWS Secrets Manager
- Secrets are injected into application pods at runtime
- No credentials are stored in source code or configuration files
- IAM roles enforce least-privilege access

---

## Observability and Monitoring

### Monitoring Scope
- Application error rates and latency
- Pod health and restart counts
- Node CPU and memory utilization
- Database storage and connection metrics

### Tooling
- Amazon CloudWatch for metrics and alarms
- Kubernetes metrics for autoscaling
- Alerting configured to notify before customer impact occurs
- For HPA (CPU / Memory auto-scaling) → install Metrics Server
- For Cluster / object monitoring (Prometheus dashboards) → install kube-state-metrics

This creates a feedback loop that enables proactive issue detection.

---

## Scaling Strategy (10× Traffic)

- Horizontal Pod Autoscaler scales application pods automatically
- Cluster capacity increases dynamically as demand grows
- Load balancer distributes traffic across healthy pods
- Database can be vertically scaled or extended with read replicas

The system scales without manual intervention.

---

## Repository Structure

- `app/` – Containerized Hello World application
- `k8s/` – Kubernetes manifests and environment overlays
- `infra/terraform/` – Infrastructure as Code
- `diagrams/` – Architecture diagram
- `runbook/` – Operational procedures
- `docs/` – Detailed design explanations
- `.github/workflows/` – CI/CD pipelines

---

## Conclusion

This solution transforms EcoStream’s fragile production setup into a resilient,
secure, and automated platform. It reduces operational risk, enforces discipline,
and ensures the system can safely scale to meet future demand.
