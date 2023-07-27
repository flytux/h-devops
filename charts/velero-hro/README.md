### Install Velero Backup


---

- Install Velero v1.8.1
- https://guide-fin.ncloud-docs.com/docs/k8s-k8suse-velero

```bash

# cli download
$ wget https://github.com/vmware-tanzu/velero/releases/download/v1.10.3/velero-v1.10.3-linux-amd64.tar.gz

$ sudo mv velero-v1.10.3-linux-amd64/velero /usr/local/bin/velero

# bucket secret 등록
$ cat << EOF >> credentials-velero
[default]
aws_access_key_id = admin
aws_secret_access_key = admin123
> cat cloud-credential
[default]
aws_access_key_id=B8706A69B7E41CE978AB
aws_secret_access_key=7C48BD41C67993AD8B693A6B335EFB6E27921AA4
region=FKR-1
server_api_uri=https://fin-ncloud.apigw.fin-ntruss.com/vserver/v2
EOF


#Velero Naver Cloud Guide

#velero snapshot-location이 설정되어 있는경우 삭제하고 velero uninstall 한다

$ velero install \
  --provider velero.io/aws \
  --bucket hro-d-nks-backup \
  --plugins velero/velero-plugin-for-aws:v1.6.2,nks.private-ncr.fin-ntruss.com/velero-plugin-for-ncloud:v0.0.7 \
  --backup-location-config region=kr-standard,s3ForcePathStyle="true",s3Url=https://kr.object.private.fin-ncloudstorage.com \
  --use-volume-snapshots=false \
  --secret-file=./cloud-credential

$ velero snapshot-location create default --provider ncloud/volume-snapshotter-plugin

$ k apply -f sample/nginx.yml

$ velero backup create nginx-backup --selector app=nginx

$ k delete ns nginx-example

$ velero restore create --from-backup nginx-backup 


```

---

```bash

# Optional

# velero install
# using CSI snapshot for nks csi storage class
# https://velero.io/docs/v1.8/csi/

$ velero install --provider velero.io/aws \
  --bucket hro-d-nks-backup --image velero/velero:v1.8.1 \
  --plugins velero/velero-plugin-for-aws:v1.7.0,velero/velero-plugin-for-csi:v0.1.0 \
  --backup-location-config region=kr-standard,s3ForcePathStyle="true",s3Url=https://kr.object.private.fin-ncloudstorage.com \
  --features=EnableCSI --backup-location-config region=FKR --snapshot-location-config region=FKR \
  --use-volume-snapshots=true --secret-file=./cloud-credential

$ velero backup create demo-backup --include-namespaces=demo --snapshot-volumes=true --storage-location=default
$ velero backup create nginx-backup --include-namespaces=nginx-example --snapshot-volumes=true --storage-location=default
```

NAS로 스토리지 클래스가 되어 있는경우 스냅샷 백업이 되지 않음

velero CSI 버전을 삭제하고 Ncloud에서 권고하는 버전으로 설치한 후 gitlab의 경우 redis master를 정지시킨 후 백업 성공함
신규 클러스터에 복구 테스트 필요
신규 테스트 복구 후 클러스터 버전 업그레이드 테스트 필요


환경구분	NAMESPACE	        내용	방	주기		보관 단위	요일	시각
개발	
            argo-system	        velero	w	MON	23:00	lst 2ea
            cattle-*            rancher
            devops-pipeline	    ci/cd	gitops
            elstic-syste
            gitlab		        velero	d       23:30	lst 3ea
            istio-system	    velero	w	MON	23:00	lst 2ea
            keycloak		    velero	w	MON	23:00	lst 2ea
            mattermost		    velero	w	MON	23:00	lst 2ea
            nexus		        velero	w	MON	23:00	lst 2ea
            rabbitmq		    velero	w	MON	23:00	lst 2ea
            redis		        velero	w	MON	23:00	lst 2ea
            redmine		        velero	w	MON	23:00	lst 2ea
            sonarqube		    velero	w	MON	23:00	lst 2ea
            tekton-*		    velero	w	MON	23:00	lst 2ea
운영	
            istio-system		velero	w	WEB	23:00	lst 2ea
            rabbitmq		    velero	w	WEB	23:00	lst 2ea
            redis		        velero	w	WEB	23:00	lst 2ea
DR	
            argo-system	argo	velero	w	FRI	23:00	lst 2ea
            cattle-*	        rancher
            istio-system		velero	w	FRI	23:00	lst 2ea
            rabbitmq		    velero	w	FRI	23:00	lst 2ea
            redis		        velero	w	FRI	23:00	lst 2ea

