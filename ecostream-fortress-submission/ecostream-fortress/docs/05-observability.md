# Observability and Monitoring

## Objective

The objective of observability is to detect application and infrastructure
issues **before they impact users**. The system must provide clear visibility
into latency, errors, traffic, and resource saturation, enabling fast and
informed operational decisions.

The observability design focuses on identifying:
- latency spikes
- 4xx and 5xx error trends
- traffic anomalies
- infrastructure saturation
- database stress conditions

---

## Observability Layers

Observability is implemented across four layers:

1. Edge and Load Balancer (ALB + WAF)
2. Kubernetes Platform (EKS)
3. Application
4. Database (RDS)

Each layer provides metrics that contribute to early detection and root cause
analysis.

---

## Edge Layer Observability (ALB & WAF)

### ALB Metrics (Amazon CloudWatch)

The Application Load Balancer is the first point where user-facing issues can
be observed.

Key metrics monitored:
- `RequestCount`
- `TargetResponseTime`
- `HTTPCode_Target_4XX_Count`
- `HTTPCode_Target_5XX_Count`
- `HTTPCode_ELB_5XX_Count`
- `HealthyHostCount` / `UnHealthyHostCount`

### Latency Monitoring
- Monitor `TargetResponseTime` using p95 and p99 percentiles
- Alerts trigger when latency exceeds baseline thresholds for a sustained period

### Error Monitoring
- **4xx errors** indicate client-side issues such as authentication failures,
  malformed requests, or blocked traffic
- **5xx errors** indicate application or dependency failures

Metric math is used to calculate error rates:
- 5xx error rate = `HTTPCode_Target_5XX_Count / RequestCount`
- 4xx error rate = `HTTPCode_Target_4XX_Count / RequestCount`

### WAF Metrics
- `BlockedRequests`
- `AllowedRequests`

A sudden increase in blocked requests may indicate an active attack or abuse
pattern.

---

## Kubernetes Platform Observability (EKS)

### Node-Level Metrics
Collected using CloudWatch Container Insights or Prometheus node exporters:
- CPU utilization
- Memory utilization
- Disk pressure
- Network throughput
- Node availability

### Pod-Level Metrics
- Pod restart counts
- CrashLoopBackOff events
- Pending pods
- CPU and memory usage per container
- CPU throttling events

These metrics help identify:
- insufficient resource allocation
- unstable application behavior
- scaling delays or failures

---

## Application Observability (Prometheus & Grafana)

### Application Metrics

The application exposes metrics consumed by Prometheus, including:
- request count by route and status code
- request latency histograms
- concurrent requests
- application-level exceptions

### Key Metrics Tracked
- Requests per second (RPS)
- p50, p95, and p99 latency
- 4xx error rate
- 5xx error rate
- Unhandled exception count

### Latency Monitoring
Latency percentiles are tracked to detect performance degradation even when
average latency appears normal.

p95 and p99 latency are primary indicators of user experience issues.

### Error Monitoring
- **5xx errors** indicate application crashes, dependency timeouts, or database
  failures
- **4xx errors** indicate client-side failures, authentication issues, or
  request validation problems

Grafana dashboards visualize trends over time and correlate latency and errors
with deployments or traffic spikes.

---

## Logging (Amazon CloudWatch Logs)

### Log Sources
- Application logs (stdout/stderr)
- Kubernetes system events
- Ingress controller logs

### Log Structure
Logs are structured to include:
- timestamp
- request identifier
- route
- status code
- latency
- error message (if applicable)

Log-based metric filters can trigger alarms on patterns such as:
- unhandled exceptions
- database connection failures
- timeout errors

---

## Database Observability (Amazon RDS)

### RDS Metrics (CloudWatch)
- `CPUUtilization`
- `FreeStorageSpace`
- `FreeableMemory`
- `DatabaseConnections`
- `ReadLatency`
- `WriteLatency`
- `DiskQueueDepth`

### Database Health Monitoring
- Alerts trigger when storage space drops below safe thresholds
- High connection counts indicate pooling or scaling issues
- Increased read/write latency signals performance bottlenecks

---

## Alerting Strategy

Alerts are designed to be **actionable and meaningful**, avoiding noise.

### Key Alert Conditions
- p95 latency exceeds defined threshold for sustained duration
- 5xx error rate exceeds acceptable percentage
- Sudden traffic drop or spike
- Pod restart rate exceeds baseline
- HPA reaches maximum replicas
- Database storage or connections approach critical limits

Alerts are routed through notification channels to ensure rapid response.

---

## Operational Response to Incidents

### Latency Spike
1. Check ALB target latency and 5xx rate
2. Review application p95/p99 latency in Grafana
3. Inspect pod CPU/memory usage and throttling
4. Validate database health metrics
5. Scale application or roll back recent deployments if required

### 5xx Error Spike
1. Identify whether errors originate from ALB or application
2. Inspect application logs for exceptions or timeouts
3. Check database connectivity and saturation
4. Roll back deployment if errors correlate with a release

### 4xx Error Spike
1. Identify affected routes
2. Check authentication or validation logic
3. Review WAF blocks and rate limits
4. Confirm API compatibility and client behavior

---

## Outcome

This observability design provides early detection of performance degradation,
failures, and capacity risks. By combining CloudWatch, Prometheus, and Grafana,
the system achieves comprehensive visibility across infrastructure, platform,
and application layers, enabling proactive and reliable operations.