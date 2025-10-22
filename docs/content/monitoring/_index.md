---
title: "Supervision – Prometheus & Grafana"
weight: 5
---


## Déploiement
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install kps prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

### ServiceMonitor MariaDB
Un `ServiceMonitor` scrute l'exporter `mariadb-metrics` dans le ns `blog`.

### Accès Prometheus & Grafana (port-forward)
```bash
kubectl -n monitoring port-forward svc/kps-kube-prometheus-stack-prometheus 9090:9090
kubectl -n monitoring port-forward svc/kps-grafana 3000:80
```

### Tests PromQL
```bash
curl -s 'http://127.0.0.1:9090/api/v1/query?query=up'
curl -s 'http://127.0.0.1:9090/api/v1/query?query=mysql_up'
```

### Dashboards recommandés
- Node / Kubelet / KSM
- **MariaDB Exporter** (7362 / 14057)
- **Blackbox** (probe_success)
