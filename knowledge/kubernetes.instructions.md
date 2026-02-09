# Kubernetes & AWS EKS Standards

## Resource Definitions

- Always set resource requests AND limits for CPU and memory
- Use `requests` for scheduling, `limits` for hard caps
- Start conservative, tune based on metrics
- Use `LimitRange` and `ResourceQuota` for namespace defaults

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

## Pod Design

- One process per container, one concern per pod
- Use init containers for setup tasks (migrations, config generation)
- Always define liveness and readiness probes
- Use `preStop` hooks for graceful shutdown
- Set `terminationGracePeriodSeconds` appropriately

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 15
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

## Deployments

- Use `RollingUpdate` strategy with `maxSurge` and `maxUnavailable`
- Set `revisionHistoryLimit` to control rollback depth
- Use Pod Disruption Budgets for high-availability services
- Label everything: `app.kubernetes.io/name`, `app.kubernetes.io/version`, `app.kubernetes.io/component`

## Helm Charts

- Use `values.yaml` for configuration, not hardcoded values in templates
- Validate inputs with `required` and `fail` functions
- Use named templates (`_helpers.tpl`) for reusable fragments
- Include NOTES.txt for post-install instructions
- Pin chart versions in `Chart.lock`
- Use `helm template` to validate before applying

## EKS Specifics

- Use IAM Roles for Service Accounts (IRSA) instead of node-level IAM
- Configure AWS Load Balancer Controller for ALB/NLB ingress
- Use EBS CSI driver for persistent volumes
- Enable cluster autoscaler or Karpenter for node scaling
- Use managed node groups with instance diversity for cost optimization
- Configure Pod Identity for AWS service access

```yaml
# IRSA annotation
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT:role/ROLE_NAME
```

## Networking

- Use `NetworkPolicy` to restrict pod-to-pod communication
- Prefer `ClusterIP` services, expose via Ingress
- Use external-dns for automatic DNS management
- Configure TLS termination at the ingress level

## Secrets Management

- Never store secrets in plain YAML or git
- Use AWS Secrets Manager with External Secrets Operator
- Or use Sealed Secrets for GitOps workflows
- Mount secrets as volumes, not environment variables (for rotation)

## Scaling

- Use HPA for CPU/memory-based scaling
- Use KEDA for event-driven scaling (SQS, RabbitMQ queues)
- Set appropriate `minReplicas` and `maxReplicas`
- Use PodTopologySpreadConstraints for even distribution

## Monitoring & Debugging

- Emit structured logs (JSON) to stdout/stderr
- Use Prometheus metrics endpoint (`/metrics`)
- `kubectl describe pod` for events
- `kubectl logs --previous` for crash logs
- `kubectl exec -it` for debugging (don't install debug tools in prod images)

## Common Pitfalls

- **Missing resource limits** -> noisy neighbor problems
- **Missing probes** -> traffic to unhealthy pods
- **No PDB** -> all pods restarted during node drain
- **Secrets in ConfigMaps** -> security risk
- **`:latest` tag** -> non-reproducible deployments. Always use specific image tags.
- **No anti-affinity** -> all replicas on same node
