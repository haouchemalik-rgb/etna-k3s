# ✅ Tests de validation – Projet K3s WordPress & Monitoring

Ce document regroupe toutes les commandes à exécuter pour vérifier que l’infrastructure K3s répond aux sujet : disponibilité des services, HTTPS, monitoring, logs, documentation, etc.

---

## 🔍 1. Vérification des pods

```bash
kubectl get pods --all-namespaces
```
✔️ Tous les pods doivent être en Running, notamment :

wordpress
mariadb
traefik
vault
prometheus, grafana, loki, promtail

2. Vérification des services

```bash
kubectl get svc --all-namespaces
```
📡 2. Vérification des services

```bash
kubectl get svc --all-namespaces
```

✔️ Le service traefik doit être de type LoadBalancer avec une IP externe ✔️ Les services wordpress, mariadb, grafana, prometheus, loki doivent être exposés

3. Vérification de l’accès HTTPS

```bash
curl -v https://web.etna.student --resolve web.etna.student:443:<traefik-ip>
```

✔️ Le certificat doit être émis par Let's Encrypt ✔️ Le site doit répondre avec HTTP/2 200 OK

🔐 4. Vérification du certificat HTTPS
bash

```bash
kubectl logs -n kube-system -l app=traefik-ingress | grep -i acme
```

✔️ Tu dois voir :

Registering... with Let's Encrypt
Successfully obtained certificate

🧭 5. Vérification de l’IngressRoute
bash

```bash
kubectl get ingressroute -n blog
```

🧠 6. Vérification des endpoints

```bash
kubectl get endpoints --all-namespaces
```
✔️ Les services doivent avoir des IP internes associées

🧱 7. Vérification des logs WordPress

```bash
kubectl logs -n blog -l app=wordpress
```
✔️ Tu dois voir :

Apache/2.4... configured
Pas d’erreurs MySQL
Pas de crash PHP

🔐 8. Vérification de Vault

```bash
kubectl get pods -n vault
kubectl logs vault-0 -n vault
```
✔️ Vault doit être en Running ✔️ Les logs doivent montrer l’initialisation et l’injection des secrets

📊 9. Vérification de Grafana

```bash
kubectl port-forward svc/kps-grafana -n monitoring 3000:80
```
✔️ Accède à http://172.16.248.21:30405/ ✔️ Login : admin / brunet_e1234@ ✔️ Les dashboards doivent afficher :

CPU / RAM / TCP
Requêtes HTTP WordPress
Codes HTTP (200, 404, 500…)
Objets K8s (Deployments, ReplicaSets…)

🔎 10. Vérification des logs dans Grafana Explore

✔️ Onglet Explore ✔️ Source : Loki ✔️ Filtres à tester :

```log
{namespace="blog"}
{container="wordpress"}
{level="error"}
{status="404"}
```

📚 11. Vérification de la documentation Hugo

✔️ Accès via : https://172.16.248.21:32443/ ✔️ Authentification basique activée ✔️ Contenu attendu :

login: admin
mdp: ChangeMe!

Déploiement de chaque service
Fonctionnement
Liens vers les fichiers GitLab
Screenshots ou extraits YAML
Dashboards et logs expliqués

🧪 12. Vérification des métriques WordPress

✔️ Dans Grafana :

Nombre de requêtes HTTP
Codes HTTP
CPU / RAM du pod WordPress

🧪 13. Vérification des métriques Kubernetes

✔️ Dans Grafana :

CPU / RAM de la VM
Node Exporter actif
Exporter visible dans Prometheus

🧪 15. Vérification des middlewares Traefik

```bash
kubectl get middleware -A

```

✔️ Tu dois voir :

redirect-https
security-headers
hugo-auth