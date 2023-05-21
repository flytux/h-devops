# MATTERMOST
************


Notification
===========
> https://docs.mattermost.com/upgrade/extended-support-release.html
`6 버전`부터는 SAML 기능을 무료버전에서 사용할 수 없다.


Install Mattermost
==================
```bash
# Create Tls Secret file
kubectl create ns mattermost
kubectl -n mattermost create secret generic tls-secret \
    --from-file=tls.crt=/Users/kihoonyang/Desktop/documents/Project/2023/hro/hro_devops/cert/mattermost.herosonsa.co.kr/merged-crt.crt \
    --from-file=tls.key=/Users/kihoonyang/Desktop/documents/Project/2023/hro/hro_devops/cert/mattermost.herosonsa.co.kr/private.key
```
```bash
helm repo add mattermost https://helm.mattermost.com
helm repo update
helm upgrade --install mattermost mattermost/mattermost-team-edition \
  -f hro-values.yaml \
  --namespace mattermost --create-namespace
```
```yaml
# NCP의 Ingress Controller에 등록되려면 
# ingressClassName: nginx 항목이 추가
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mattermost-ingress
  namespace: mattermost
spec:
  tls:
    - hosts:
      - mattermost.herosonsa.co.kr
      secretName: tls-secret
  ingressClassName: nginx
  rules:
  - host: mattermost.herosonsa.co.kr
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mattermost-team-edition
            port:
              number: 8065
```

mmctl
=====
> https://docs.mattermost.com/manage/mmctl-command-line-tool.html#

* Install
```bash
brew install mmctl
mmctl -h
```
* Login
```bash
mmctl auth login https://mattermost.herosonsa.co.kr --username devops
Connection name: `null`
```
* Get Team List
```bash
mmctl team list
chl
core
hro
```
* Get Channel List
```bash
mmctl channel list core
hro-com-ncrm
hro-frontend
```
* Create User
```bash
mmctl user create --email user02@herosonsa.co.kr --username use02 --password user02@herosonsa.co.kr
Created user use02
```
* Add Team User
```bash
mmctl team users add core user02@herosonsa.co.kr use02
```
* Add Channel User
```bash
# Team Member여야 Channel에 들어올 수 있다.
mmctl channel users add core:hro-frontend user02@herosonsa.co.kr user02
```