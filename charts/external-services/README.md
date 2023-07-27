### External Service Endpoint

---

- create service and endpoint with same name
- create service monitor with namespace and label selector
- check prometheus service discovery


```bash
---
apiVersion: v1
kind: Service
metadata:
  name: core-web
  namespace: monitor-dev
  labels:
    app: prometheus-node-exporter
spec:
  ports:
    - name: metrics
      port: 9100
      protocol: TCP
      targetPort: 9100
  type: ClusterIP
---
apiVersion: v1
kind: Endpoints
metadata:
  name: core-web
  namespace: monitor-dev
  labels:
    app: prometheus-node-exporter
subsets:
  - addresses:
      - ip: 10.3.20.12
    ports:
      - name: metrics
        port: 9100
        protocol: TCP
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: core-web-monitor
  namespace: monitor-dev
spec:
  endpoints:
    - port: metrics
  jobLabel: jobLabel
  namespaceSelector:
    matchNames:
      - monitor-dev
  selector:
    matchLabels:
      app: prometheus-node-exporter
```
