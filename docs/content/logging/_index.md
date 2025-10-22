---
title: "Journalisation – Loki & Promtail"
weight: 6
---


## Loki (mode SingleBinary)
- Stockage **filesystem**, schema **v12 + boltdb-shipper**
- `allow_structured_metadata: false` pour éviter le crash avec v12

### Vérifs Loki
```bash
kubectl -n monitoring get pods -l app.kubernetes.io/name=loki -o wide
kubectl -n monitoring port-forward svc/loki 3100:3100 &
curl -s http://127.0.0.1:3100/ready
curl -sG 'http://127.0.0.1:3100/loki/api/v1/labels'
```

## Promtail
- DaemonSet collectant `/var/log/pods/**/containers/*.log`
- Client → `http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push`

### Vérifs Promtail
```bash
kubectl -n monitoring logs ds/promtail --tail=50
# Ne doit PAS contenir: "at least 2 live replicas required"
```

## Dans Grafana → Explore
Exemples de requêtes LogQL :
```logql
{namespace="monitoring"} |= "error"
{app="wordpress"}
{component="prometheus-operator"}
```
