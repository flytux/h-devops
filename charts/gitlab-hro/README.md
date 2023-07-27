### Gitlab upgarde procedure


**1. Check gitlab helm chart relesase notes**

**2. Fetch latest version of gitlab helm-chart**

```bash

 $ helm search repo gitlab
 $ helm fetch gitlab/gitlab

```

**2. Check chart / sub-chart container images to upgrade, If there are missing images in Naver Cloud Private Registry > Pull / Tag / Push appropriate images from registry.gitlab.com**

```bash
 # Postgres New Image Upgrade
 $ docker pull bitnami/postgresql:13.7.0
 $ docker tag bitnami/postgresql:13.7.0 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/bitnami/postgresql:12.7.0
 $ docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/bitnami/postgresql:12.7.0

```

**2. update values.yaml "gitlabVersion" to possible release version**

```bash

  gitlabVersion: "$NEW_VERSION"

```
**3. update proper values of sub-charts, if postgres image upgrades to newer version, check and update postgres sub-chart values in values.yaml file in current directory**

```bash

postgresql:
  global:
    imageRegistry: tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops

  image:          # New Image Tag
    tag: 13.7.0   # to 13.7.0

```

**4. helm upgrade with new values**

```bash

  $ helm upgrade gitlab -f values.yaml $NEW_CHART_FILE_NAME$ -n gitlab
  $ helm history gitlab -n gitlab

```

---

## gitlab upgrade to 16.1.2 23/07/10

```bash
# Gitlab Upgrade Image Pull / Tag / Push 

docker pull registry.gitlab.com/gitlab-org/build/cng/kubectl:v16.1.2
docker tag registry.gitlab.com/gitlab-org/build/cng/kubectl:v16.1.2 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/kubectl:v16.1.2
docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/kubectl:v16.1.2
docker pull registry.gitlab.com/gitlab-org/build/cng/certificates:v16.1.2
docker tag registry.gitlab.com/gitlab-org/build/cng/certificates:v16.1.2 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/certificates:v16.1.2
docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/certificates:v16.1.2
docker pull registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce:v16.1.2
docker tag registry.gitlab.com/gitlab-org/build/cng/gitlab-toolbox-ce:v16.1.2 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-toolbox-ce:v16.1.2
docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-toolbox-ce:v16.1.2
docker pull registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce:v16.1.2
docker tag registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce:v16.1.2 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-sidekiq-ce:v16.1.2
docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-sidekiq-ce:v16.1.2
docker pull registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce:v16.1.2
docker tag registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce:v16.1.2 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-webservice-ce:v16.1.2
docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-webservice-ce:v16.1.2
docker pull registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v16.1.2
docker tag registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce:v16.1.2 tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-workhorse-ce:v16.1.2
docker push tbd5d1uh.private-ncr.fin-ntruss.com/k8s/dev/devops/gitlab-org/build/cng/gitlab-workhorse-ce:v16.1.2
```

# Upgade 순서 (23/07/13)

- 복구 대상 클러스터에 gitlab 관련 pv / pvc 가 있는 경우 삭제 하여 초기화 
- velero 백업 으로 복구 v15.1 gitlab-backup-v3
- 복구 버전에서 pg_dump로 gitlabhq_production backup
- pg_dump -U postgres -d gitlabhq_production > backup.sql /bitnami/postgres 디렉토리 에서 실행
- password는 postgres pod에서 env로 확인
- statefulests - postgres / gitary / redis 삭제 후 pvc - pv 삭제
- helm upgrade -f values gitlab-7.1.2.tgz 
- postgres pod 에서 postgres 사용자로 복구 
- psql -U postgres -d gitlabhq_production
- \i backup.sql
- re-deploy sts gitaly / redis
- EOF

# Upgrade Update (23/7/14)

velero restore create --from-backup gitlab-backup-v4
k exec -it gitlab-postgresql-0 bash
pg_dump -U postgres -d gitlabhq_production > backup.sql
k cp gitlab-postgresql-0:/bitnami/postgresql/backup.sql ./backup.sql-v4
k get sts
k delete sts gitlab-gitaly gitlab-postgresql gitlab-redis-master
k delete pvc data-gitlab-postgresql-0
k get pv | grep -i gitlab
k delete pv pvc-38badd8170c6491c9094c43a03
helm upgrade -i gitlab -f values.yaml gitlab-7.1.2.tgz
k cp ./backup.sql-v4  gitlab-postgresql-0:/bitnami/postgresql/backup.sql-v4
k exec -it gitlab-postgresql-0 bash
psql -U postgres -d gitlabhq_production
\i \i backup.sql-v4
k edit ing gitlab-webservice-default
helm delete gitlab
helm upgrade -i gitlab -f values.yaml gitlab-7.1.2.tgz


# Upgrade Update (23/7/17)

# 원 버전 백업으로 복구
velero restore create --from-backup gitlab-backup-v4

# 데이터베이스 덤프
k exec -it gitlab-postgresql-0 bash
pg_dump -U postgres -d gitlabhq_production > backup.sql
postgres 패스워드 : d3ZNpIJvt6z08lU7U9i3K8orlBp0ZXW3VFUVCfXaLFGErdiGAP635TDYFhPZ0yfT
k cp gitlab-postgresql-0:/bitnami/postgresql/backup.sql ./backup.sql-230717

# postgres PVC / PV 삭제
k get sts
k delete sts gitlab-gitaly gitlab-postgresql gitlab-redis-master
k delete pvc data-gitlab-postgresql-0
k get pv | grep -i gitlab
k delete pv pvc-38badd8170c6491c9094c43a03

# Upgrade 버전 설치
helm upgrade -i gitlab -f values.yaml gitlab-7.1.2.tgz  --set gitlab.migrations.enabled=false

# Postgres DB Import
k cp ./backup.sql-230717  gitlab-postgresql-0:/bitnami/postgresql/backup.sql
k exec -it gitlab-postgresql-0 bash
psql -U postgres -d gitlabhq_production
\i backup.sql

# Gitlab 신규 버전 삭제 후 재설치
helm delete gitlab
helm upgrade -i gitlab -f values.yaml gitlab-7.1.2.tgz



