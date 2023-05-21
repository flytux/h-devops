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
