# NKS
*****


Description
===========
* DEV Cluster
  * uuid : 8faad694-ac90-4616-881d-9d1d893f1112
  * size : (8Core 32G) * 3
  * master version : 1.24.10
* PRD
  * uuid : ...
  * size : (8Core 32G) * x
  * master version : 1.24.10
* DR
  * uuid : ...
  * size : (8Core 32G) * x
  * master version : 1.24.10


Install NKS Cluster
===================
* Cluster 설정
* Node Pool 설정
* 인증키 설정
* 최종확인

  > 최종설치까지 약 20분이상 걸림
  

IAM Authentication
==================
* Install
    ```bash
    brew tap NaverCloudPlatform/tap
    brew install ncp-iam-authenticator
    ```

* Create kubeconfig
    ```bash
    ncp-iam-authenticator create-kubeconfig --region FKR --clusterUuid 8faad694-ac90-4616-881d-9d1d893f1112 --profile HRO-devops --output kubeconfig-devops-hro.yaml --debug
    ```

* Import kubeconfig at Lens
  * `kubeconfig-devops-hro.yaml` 파일 내용을 복사
  * Add Cluster from Kubeconfig 붙여넣기
  * Add clusters

* Check kubectl command at Lens
  * New `Terminal session`
    ```bash
    > kubectl get no   
    NAME                   STATUS   ROLES    AGE   VERSION
    pool-hrodwrkn-w-1hcb   Ready    <none>   23d   v1.24.10
    pool-hrodwrkn-w-1hcc   Ready    <none>   23d   v1.24.10
    pool-hrodwrkn-w-1hcd   Ready    <none>   23d   v1.24.10
    ```


Install Ingress Nginx Controller
================================
* nginx controller 설치
  > - URL : https://kubernetes.github.io/ingress-nginx/deploy/
  > - Version : v1.7.0
  ```bash
  helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx --create-namespace
  ```
* NCP의 Load Balaner내 ingress 생성 확인    