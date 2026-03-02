# Deployment Runbook – Safe Production Releases

## Objective

Enable reliable, repeatable, and reversible deployments without direct
server access. The deployment process must minimize risk while allowing
frequent releases.

---

## Deployment Principles

- No SSH access to production servers
- Immutable container images
- Declarative Kubernetes deployments
- Health-based traffic routing
- Fast rollback capability

---

## Deployment Flow

### 1. Build Phase
- Application source code is packaged into a container image
- Image is tagged immutably (commit hash or version)
- Image is pushed to Amazon ECR

### 2. Pre-Deployment Validation
- Container starts successfully
- Health endpoint responds correctly
- Configuration and secrets are resolved at runtime

### 3. Deployment Execution
- Kubernetes manifests are applied to the target environment
- Rolling updates replace pods gradually
- Readiness probes ensure traffic is sent only to healthy pods

### 4. Post-Deployment Monitoring
- Application latency (p95/p99)
- 4xx and 5xx error rates
- Pod restarts and crash loops
- Database health metrics

---

## Release Safety Controls

- Rolling updates limit blast radius
- Canary or blue/green strategies may be used for high-risk releases
- Deployment is aborted automatically if health checks fail

---

## Rollback Procedure

Rollback is performed by:
1. Re-deploying the previous container image
2. Allowing Kubernetes to restore the last stable ReplicaSet
3. Verifying application health metrics return to baseline

Rollback does not require database rollback if migrations are backward compatible.

---

## Production Deployment Checklist

- No unresolved alerts prior to release
- Database migrations reviewed and approved
- Monitoring dashboards open during deployment
- Rollback image identified and available