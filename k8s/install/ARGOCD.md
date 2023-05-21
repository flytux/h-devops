# ARGOCD
********

Description
===========
* Version : 2.6.7
* Release Date : 


Install ArgoCD
==============
```bash
# HA
kubectl apply -n argo-system \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.7/manifests/ha/install.yaml
```

> TLS 인증서 내용 적용시 `argocd-secret`의 파일을 삭제하지 말고 수정해서 반영
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argo-system
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
    - host: argocd.herosonsa.co.kr
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  name: https
  tls:
    - hosts:
        - argocd.herosonsa.co.kr
      secretName: argocd-secret # do not change, this is provided by Argo CD
```

Connect ArgoCD
==============
* URL : https//argocd.herosonsa.co.kr
* Initial Account
```bash
echo "Username: \"admin\""
echo "Password: $(kubectl -n argo-system get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
#Username: "admin"
#Password: L5laRcJpeetARabB
```