# Network Perimeter and Secrets Management

## Network Design
The network follows a private-by-default model:
- Public access limited to load balancer
- No direct internet access to compute or database layers
- Strict traffic rules enforced via security groups

## Secrets Handling
- Secrets are centrally managed
- Access is granted only to authorized workloads
- Secrets are never written to disk or committed to repositories

This significantly reduces exposure and audit risk.