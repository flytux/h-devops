### Keycloak Backup


- cronjob으로일 2회 백업
- minio s3 keycloak-backup bucket에 저장
- 복구 시 백업된 devops-realm.json을 받아서
- k create configmap devops-realm으로 만들어서
- keycloak helm upgrade 수행
- keycloak helm chart value에extra argument로 import 태스크 포함

```bash
$ k create configmap devops-realm --from-file=devops-realm.json -n keycloak
$ helm upgrade -i keycloak -f values.yaml keycloak-13.4.0.tgz -n keycloak
```

