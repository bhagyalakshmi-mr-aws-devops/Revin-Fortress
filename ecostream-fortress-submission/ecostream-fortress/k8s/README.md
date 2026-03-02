# Kubernetes Deployment Design

## Purpose

Kubernetes is used to provide:
- application resiliency
- automated scaling
- controlled deployments
- clear separation between environments

---

## Base Manifests

The `base/` directory defines common resources:
- Deployment
- Service
- Ingress
- Horizontal Pod Autoscaler

These files represent the standard production configuration.

---

## Environment Overlays

The `overlays/` directory customizes deployments for:
- Development
- Staging
- Production

Environment differences include:
- replica counts
- container image tags
- resource sizing

This ensures consistent behavior while allowing safe variation.

---

## Health Management

- Readiness probes control traffic routing
- Liveness probes detect hung containers
- Resource limits prevent noisy-neighbor issues