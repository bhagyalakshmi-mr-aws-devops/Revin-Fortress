# Disaster Recovery Runbook

## Objective

Ensure application data can be recovered from failures such as hardware loss,
human error, or corrupted deployments with minimal downtime and data loss.

---

## Database Protection Strategy

The system uses Amazon RDS PostgreSQL with:
- Multi-AZ deployment
- Automated backups
- Point-in-Time Recovery (PITR)
- Encrypted storage

---

## Failure Scenarios and Response

### Availability Zone Failure
- RDS automatically fails over to standby instance
- Application reconnects automatically
- No manual intervention required

### Accidental Data Deletion or Bad Migration
1. Identify the time just before the incident
2. Restore database using PITR to a new instance
3. Validate data integrity
4. Update database endpoint or secret
5. Restart application pods to reconnect

### Complete Database Loss
- Restore from the most recent snapshot
- Reapply schema migrations if required
- Resume service once validation completes

---

## Recovery Objectives

- Recovery Time Objective (RTO): Minutes
- Recovery Point Objective (RPO): Minutes (based on PITR granularity)

---

## Post-Recovery Actions

- Root cause analysis
- Validate backup integrity
- Review access controls and change process