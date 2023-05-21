# PODMAN
********


Description
===========
* version : 4.1.1 ( to-do : check `subscription-manager`)
* release date : 2022.9


Install Podman
==============
```bash
#Server Update
yum update
yum install epel-release # can do??
#Install Podman
yum install podman

#Check Version
podman --version
podman version 4.1.1
```


Set Config
=========
```bash
# change repo location (LVM)
mkdir -p /hro_app/app/containers/data

vi /etc/containers/storage.conf
rootless_storage_path = "/hro_app/app/containers/data"

# set private registry ( add ncp container registry )
vi /etc/containers/registries.conf
unqualified-search-registries = ["hello-hro.ncr.fin-ntruss.com", "registry.access.redhat.com", "registry.redhat.io", "docker.io"]

# add privileged port ( 1024 > port )
vi /etc/sysctl.conf
net.ipv4.ip_unprivileged_port_start=80

# check login
pdoman login -u <access-key-id> <registry-name>.ncr.fin-ntruss.com -p <secret-key>
Login Succeeded!
```


Run Podman
==========
```bash
# sample
podman run -d -p 8888:8888 -it --name prm-frontend nginx:latest
# check conatiner
podman container list
CONTAINER ID  IMAGE                           COMMAND               CREATED        STATUS            PORTS                   NAMES
41c4e17ed6d0  docker.io/library/nginx:latest  nginx -g daemon o...  4 minutes ago  Up 4 minutes ago  0.0.0.0:8888->8888/tcp  prm-frontend
```


Deploy Podman
=============
```bash
# example
podman rm -f {ContainerName}  # 컨테이너 삭제
podman rmi -f {ImageName}:{tag} # 이미지 삭제
podman run -d -p 8080:8080 -it --name {ContainerName} {ImageName}:{tag} # 새로운 컨테이너 시작
podman ps --filter "name=test111" --format "table {{.Status}}" # 컨테이너 상태 확인
```
