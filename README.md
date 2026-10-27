# WordPress haute disponibilité sur K3s — HTTPS, Vault, supervision & logs

> Projet ETNA — module ISR-CLO4 · Octobre 2025 · Projet de groupe

Déploiement d'une plateforme WordPress complète sur un cluster **K3s**, avec exposition HTTPS via Traefik, injection des secrets par **HashiCorp Vault**, supervision **Prometheus / Grafana / Blackbox**, centralisation des logs **Loki / Promtail** et un site de documentation **Hugo** conteneurisé.

**Compétences mises en œuvre :** Kubernetes / K3s · Traefik (IngressRoute, middlewares) · HashiCorp Vault (agent injector) · Prometheus Operator (ServiceMonitor, PrometheusRule, Probe) · Grafana · Loki / Promtail · MariaDB · Docker multi-stage · Hugo

---

## Architecture

```
                 ┌─────────────── Traefik (web / websecure) ───────────────┐
 Client ──HTTPS──▶  redirection HTTP→HTTPS · TLS · IngressRoutes            │
                 └──────┬──────────────────────────────┬───────────────────┘
                        ▼                              ▼
              ns blog : WordPress 6.6           ns blog : site Hugo (Nginx)
                        │                         (authentification basique)
                        ▼
              ns blog : MariaDB (StatefulSet + PVC) ◀── secrets injectés par Vault
                        │
 ns monitoring : Prometheus ◀─ ServiceMonitors (MariaDB exporter, Traefik)
                 Blackbox probe (disponibilité WordPress) · Alertes · Grafana
                 Loki ◀─ Promtail (logs de tous les pods)
```

## Contenu

| Fichier | Rôle |
|---|---|
| `manifests/00-namespace.yaml` → `02-pvc.yaml` | Namespace, secrets initiaux, stockage persistant |
| `manifests/03-mariadb.yaml`, `03b-mariadb-exporter.yaml` | Base MariaDB et son exporter Prometheus |
| `manifests/04-wordpress.yaml`, `04-wp-http.yaml` | Déploiement WordPress et route HTTP |
| `manifests/05-wordpress-https.yaml`, `05b-wp-redirect-mw.yaml` | Route HTTPS et middleware de redirection |
| `manifests/06-wordpress-vault.yaml` | WordPress avec identifiants BDD injectés par l'agent Vault |
| `manifests/monitoring-*.yaml` | ServiceMonitors, sonde Blackbox, règles d'alerte (`WordPressDown`, `MySQLDown`), Grafana |
| `manifests/loki-*.yaml`, `promtail-values.yaml` | Stack de logs |
| `traefik/traefik-configmap.yaml` | Configuration TLS de Traefik |
| `docs/` | Site de documentation Hugo (build multi-stage → Nginx) et son déploiement |

## Déploiement

```bash
kubectl apply -f manifests/00-namespace.yaml -f manifests/01-secrets.yaml -f manifests/02-pvc.yaml
kubectl apply -f manifests/03-mariadb.yaml -f manifests/03b-mariadb-exporter.yaml
kubectl apply -f manifests/04-wordpress.yaml -f manifests/05-wordpress-https.yaml -f manifests/05b-wp-redirect-mw.yaml
kubectl apply -f manifests/monitoring-rules.yaml -f manifests/monitoring-mariadb-sm.yaml \
              -f manifests/monitoring-traefik-sm.yaml -f manifests/monitoring-wp-probe.yaml
```

Prérequis : K3s (Traefik inclus), Helm, kube-prometheus-stack, Loki/Promtail et Vault installés via leurs charts officiels.

La procédure de recette complète (pods, HTTPS, Vault, métriques, logs, documentation) est décrite dans **[VALIDATION.md](VALIDATION.md)**.

## Notes

- `01-secrets.yaml` contient des mots de passe **de démonstration** utilisés au premier démarrage ; la version cible (`06-wordpress-vault.yaml`) récupère les identifiants depuis Vault.
- Le certificat TLS est auto-signé (environnement de lab, conformément au sujet).
