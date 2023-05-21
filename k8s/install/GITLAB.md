# GITLAB
**********

Description
===========
* Version : 15.10.2
* Edition : ce


Before Install
==============
* Create Realm
  > reference : Config Certificate @ KEYCLOAK.md


Install GitLab
==============
```bash
# Create Tls Secret file
kubectl create ns gitlab-system
kubectl -n gitlab create secret generic tls-secret \
    --from-file=tls.crt=/Users/kihoonyang/Desktop/documents/Project/2023/hro/hro_devops/cert/keycloak.herosonsa.co.kr/merged-crt.crt \
    --from-file=tls.key=/Users/kihoonyang/Desktop/documents/Project/2023/hro/hro_devops/cert/keycloak.herosonsa.co.kr/private.key
```
```bash
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab -f hro-values.yaml \
  --namespace gitlab-system --create-namespace
```

Set DNS Record
==============
* Add Record
  * host : gitlab
  * record type : LB VPC
  * value : k8s ingress
* Deploy


Connect GitLab
==============
* URL : gitlab.herosonsa.co.kr
* Admin Account
  * Initial ID : root
  * Initial PW
    ```bash
    kubectl get secret gitlab-gitlab-initial-root-password -n gitlab-system -ojsonpath='{.data.password}' | base64 --decode ; echo
    #qTUpRPjjl8DBWUjnbvRWtEudjXodSUA2IVczWlcKbbljbYpa4MNryWxNClCqkDNJ
    ```

Set GitLab Config
================
* Admin > Settings > General > Sign-up restrictions > Sign-up enabled `uncheck`


Organization
============
* Create Repository
  > reference : Repository List (excel)

* Create Access Token ( `root` for `userlist` )
  * app > Settings > Access Tokens
    * Token name : app-devops
    * access token : `glpat-PviTstdrmCN3tyf_fxUn`

* Create Access Token
  * app > Settings > Access Tokens
    * Token name : app-devops
    * role : Maintainer
    * access token : `glpat-PviTstdrmCN3tyf_fxUn`



For Devops
==========
* Get group list ( need `root` token )
```bash
# get root group id (ex.app)
  curl --header "Authorization: Bearer glpat-QnnzLtQKazeR4SB8-bac" \
  "https://gitlab.herosonsa.co.kr/api/v4/groups" \
  --insecure | jq '.[] | select(.id != 2) | {id, name}'
```
* Get project list
```bash
curl --header "Authorization: Bearer glpat-Jn5-p8G5Jyscy_bemjGe" \
  "https://gitlab.herosonsa.co.kr/api/v4/projects" \
  --insecure | jq '.[] | select(.id != 1) | {id, name}'
```

* Get User list ( need `root` token )
```bash
curl --header "Authorization: Bearer glpat-QnnzLtQKazeR4SB8-bac" \
  "https://gitlab.herosonsa.co.kr/api/v4/users" \
  --insecure | jq '.[] | select(.identities[0].provider == "saml" and .note == null) | {id, username, name, note, created_at}'
```

* Add Group Member ( need `root` token )
  > - 0 : No access
  > - 5 : Minimal access
  > - 10 : Guest
  > - 20 : Reporter
  > - 30 : `Developer`
  > - 40 : Maintainer
  > - 50 : Owner
```bash
curl --request POST --header "PRIVATE-TOKEN: glpat-QnnzLtQKazeR4SB8-bac" \
  --insecure "https://gitlab.herosonsa.co.kr/api/v4/groups/16/members" \
  --data "user_id=:userid&access_level=30" 
```



> Gitlab Backup : object storage 저장은 gitlab toolbox에서 aws s3 api를 이용해서 동작하므로 `awscli`로 s3로 전송해야함(helm chart로 설정 안됨)
> https://docs.gitlab.com/charts/advanced/external-object-storage/
> https://docs.gitlab.com/charts/troubleshooting/kubernetes_cheat_sheet.html#gitlab-specific-kubernetes-information

* Create Object Storage(NCP)
  * Bucket Name : hro-d-devops-gitlab-backups

* Create Service Account / Secret
```bash
# gitlab backup용 sa 생성
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-backup
  namespace: gitlab
secrets:
  - name: gitlab-backup-token
---
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-backup-token
  namespace: gitlab
  annotations:
    kubernetes.io/service-account.name: gitlab-backup
type: kubernetes.io/service-account-token  
EOF
```
```bash
# check token
kubectl -n gitlab describe secret $(kubectl -n gitlab get secret | grep gitlab-backup | awk '{print $1}')
```

* Configure Role and RoleBinding
```bash
# role, role binding 생성
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: gitlab
  name: gitlab-backup-role
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list"]
  - apiGroups: [""]
    resources: ["pods/exec"]
    verbs: ["create"] 
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: gitlab
  name: gitlab-backup-rb
subjects:
  - kind: ServiceAccount
    name: gitlab-backup
    namespace: gitlab
roleRef:
  kind: Role
  name: gitlab-backup-role
  apiGroup: rbac.authorization.k8s.io
EOF
```

* Backup Script
```bash
kubectl create configmap gitlab-backup-job -n gitlab --from-file=run-backup.sh
```
```yaml
# ConfigMap 저장
apiVersion: v1
kind: ConfigMap
metadata:
  name: gitlab-backup-job
  namespace: gitlab
data:
  run-backup.sh: >-
    kubectl -n gitlab exec -it -c toolbox \
    $( kubectl get pod -n gitlab -l app=toolbox --no-headers -o custom-columns=":metadata.name" ) \
    -- /bin/bash <<EOF

    aws configure set aws_access_key_id B8706A69B7E41CE***** --profile default \
    && aws configure set aws_secret_access_key 7C48BD41C67993AD8B693A6B335EFB6E279***** --profile default \

    && aws configure set region kr-standard --profile default \

    && aws configure set output "json" --profile default

    export BACKUP_BUCKET_NAME=hro-d-devops-gitlab-backups

    backup-utility --s3tool awscli --aws-s3-endpoint-url https://kr.object.private.fin-ncloudstorage.com --aws-region kr-standard
    EOF
binaryData: {}
```
* Reference execute code
```bash
# set config
aws configure set aws_access_key_id  B8706A69B7E41CE***** &&
aws configure set aws_secret_access_key 7C48BD41C67993AD8B693A6B335EFB6E279***** &&
aws configure set region kr-standard &&
aws configure set output json

# run backup at toolbox pod
export BACKUP_BUCKET_NAME=hro-d-devops-gitlab-backups
backup-utility --s3tool awscli \
--aws-s3-endpoint-url https://kr.object.private.fin-ncloudstorage.com  \
--aws-region kr-standard
```

```bash
kubectl create secret generic gitlab-s3-secret -n gitlab \
--from-literal=aws_access_key_id=B8706A69B7E41CE***** \
--from-literal=aws_secret_access_key=7C48BD41C67993AD8B693A6B335EFB6E279***** \
--from-literal=backup_bucket_name=hro-d-devops-gitlab-backups
```

```bash
  kubectl -n gitlab exec -it -c toolbox \
  $( kubectl get pod -n gitlab -l app=toolbox --no-headers -o custom-columns=":metadata.name" ) \
  -- /bin/sh <<EOF
  aws configure set aws_access_key_id  B8706A69B7E41CE***** --profile default \
  && aws configure set aws_secret_access_key 7C48BD41C67993AD8B693A6B335EFB6E279***** --profile default \
  && aws configure set region kr-standard --profile default \
  && aws configure set output "json" --profile default
  export BACKUP_BUCKET_NAME=gitlab-backups
  backup-utility --s3tool awscli --aws-s3-endpoint-url https://kr.object.private.fin-ncloudstorage.com --aws-region kr-standard
  EOF
```

* Create Cronjob
```bash
# 매일 23시 백업수행
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: gitlab-backup-job
  namespace: gitlab
spec:
  schedule: "0 23 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: gitlab-backup
          automountServiceAccountToken: true
          imagePullSecrets:
            - name: hero-reg
          containers:
          - name: gitlab-backup
            image: tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/bitnami/kubectl:1.24
            imagePullPolicy: IfNotPresent
            command: ["/bin/bash"]
            args: ["-c", "/usr/bin/run-backup.sh"]
            volumeMounts:
              - name: script-volume
                mountPath: /usr/bin
          volumes:
            - name: script-volume
              configMap:
                name: gitlab-backup-job
                defaultMode: 0777
          restartPolicy: OnFailure
EOF
```