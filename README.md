## hro-devops-repository
> Creator: devops@herosonsa.co.kr
> Date: 2023/3/24

## Description
* hro-devops-repository에 대한 설명을 작성하세요
- 히어로 손사 Infra Git Repo

## To-do
- Move Directory
  - hro-devops-repository/charts -> hro-devops-repository/k8s/install/helm/charts
  - hro-devops-repository/pipeline -> hro-devops-repository/k8s/gitops/pipline


## GitLab Repository List
|level| | | | Content            |gitURL|
|:----|:----|:----|:----|:-------------------|:----|
|app|core|hro-frontend| | core-frontend      |https://gitlab.herosonsa.co.kr/app/core/hro-frontend.git|
| | |hro-com-ncrm| | NCRM-E Server      |https://gitlab.herosonsa.co.kr/app/core/hro-com-ncrm.git|
| | |hro-ccm-backend| | 보상-업무              |https://gitlab.herosonsa.co.kr/app/core/hro-ccm-backend.git|
| | |hro-ccm-batch| | 보상-배치              |https://gitlab.herosonsa.co.kr/app/core/hro-ccm-batch.git|
| | |hro-com-backend| | 공통-업무              |https://gitlab.herosonsa.co.kr/app/core/hro-com-backend.git|
| | |hro-com-batch| | 공통-배치              |https://gitlab.herosonsa.co.kr/app/core/hro-com-batch.git|
| | |hro-smv-backend| | 현장출동-업무            |https://gitlab.herosonsa.co.kr/app/core/hro-smv-backend.git|
| | |hro-sts-backend| | 통계-업무              |https://gitlab.herosonsa.co.kr/app/core/hro-sts-backend.git|
| | |framework|hro-fwk-backend| framework공통        |https://gitlab.herosonsa.co.kr/app/core/framework/hro-fwk-backend.git|
| | | |hro-fwk-batch| framework배치        |https://gitlab.herosonsa.co.kr/app/core/framework/hro-fwk-batch.git|
| |channel|hro-prm-frontend| | channel-frontend   |https://gitlab.herosonsa.co.kr/app/channel/hro-prm-frontend.git|
| | |hro-prm-backend| | 채널- backend        |https://gitlab.herosonsa.co.kr/app/channel/hro-prm-backend.git|
| | |hro-mobile-fronend| | 채널-mobile-frontend |https://gitlab.herosonsa.co.kr/app/channel/hro-mobile-fronend.git|
| | |hro-mobile-backend| | 채널-mobile-backend  |https://gitlab.herosonsa.co.kr/app/channel/hro-mobile-backend.git|
| | |hro-mobile-app| | 채널-mobile-app      |https://gitlab.herosonsa.co.kr/app/channel/hro-mobile-app.git|
| |hro-helloworld| | | welcome            |https://gitlab.herosonsa.co.kr/app/hro-helloworld.git|


## NKS Namespace List
- ns-app-{service}-dev : dev 환경 application (backend/frontend) - 개발/test 클러스터
- ns-app-{service}-test : test 환경 application (backend/frontend) - 개발/test 클러스터
- ns-app-{service}-prd : prod 환경 application (backend/frontend) - 운영 클러스터
- istio-system : istio
- argo-system : argocd / argo rollout
- cattle-system : rancher
- elastic-system : efk
- tekton-pipelines : pipeline / pipelinerun
- gitlab
- keycloak
- nexus
- sonarqube
- velero

...

|URL  |namespace|service|port| pod                          |
|:----|:----    |:----  |:---|:-----------------------------|
|https://devbiz.herosonsa.co.kr/com/api|ns-app-core-dev|core-com-svc-dev|8070| core-com-api-dev-{random}    |
|https://devbiz.herosonsa.co.kr/com/batch|ns-app-core-dev|core-com--batch-svc-dev|8070| core-com-batch-dev-{random}  |
|https://devbiz.herosonsa.co.kr/ccm/api|ns-app-core-dev|core-ccm-svc-dev|8070| core-ccm-api-dev-{random}    |
|https://devbiz.herosonsa.co.kr/ccm/batch|ns-app-core-dev|core-ccm-batch-svc-dev|8070| core-ccm-batch-dev-{random}  |
|https://devbiz.herosonsa.co.kr/smv/api|ns-app-core-dev|core-smv-svc-dev|8070| core-smv-api-dev-{random}    |
|https://devbiz.herosonsa.co.kr/sts/api|ns-app-core-dev|core-sts-svc-dev|8070| core-sts-api-dev-{random}    |
|https://testbiz.herosonsa.co.kr/com/api|ns-app-core-test|core-com-svc-test|8080| core-com-api-test-{random}   |
|https://testbiz.herosonsa.co.kr/com/batch|ns-app-core-test|core-com--batch-svc-test|8080| core-com-batch-test-{random} |
|https://testbiz.herosonsa.co.kr/ccm/api|ns-app-core-test|core-ccm-svc-test|8070| core-ccm-api-test-{random}   |
|https://testbiz.herosonsa.co.kr/ccm/batch|ns-app-core-test|core-ccm-batch-svc-test|8080| core-ccm-batch-test-{random} |
|https://testbiz.herosonsa.co.kr/smv/api|ns-app-core-test|core-smv-svc-test|8080| core-smv-api-test-{random}   |
|https://testbiz.herosonsa.co.kr/sts/api|ns-app-core-test|core-sts-svc-test|8080| core-sts-api-test-{random}   |
|https://biz.herosonsa.co.kr/com/api|ns-app-core-prd|core-com-svc-prd|8090| core-com-api-prd-{random}    |
|https://biz.herosonsa.co.kr/com/batch|ns-app-core-prd|core-com--batch-svc-prd|8090| core-com-batch-prd-{random}  |
|https://biz.herosonsa.co.kr/ccm/api|ns-app-core-prd|core-ccm-svc-prd|8090| core-ccm-api-prd-{random}    |
|https://biz.herosonsa.co.kr/ccm/batch|ns-app-core-prd|core-ccm-batch-svc-prd|8090| core-ccm-batch-prd-{random}  |
|https://biz.herosonsa.co.kr/smv/api|ns-app-core-prd|core-smv-svc-prd|8090| core-smv-api-prd-{random}    |
|https://biz.herosonsa.co.kr/sts/api|ns-app-core-prd|core-sts-svc-prd|8090| core-sts-api-prd-{random}    |

> UI : https://devbiz.herosonsa.co.kr/ncrm/index.html
