**Tekton pipeline installation procedure**

- 1. Review installation yaml files : container images

- 2. Apply pipelines, trigger, interceptor, dashboard yaml

```bash

 $ kubectl apply -f tekton-pipeline-0.47.yml  
 $ kubectl apply -f tekton-triggers-v0.23.1.yml
 $ kubectl apply -f interceptors-v0.23.1.yml  
 $ kubectl apply -f tekton-dashboard-v0.34.yml  

```

- 3. Install tekton-dashboard oauth-proxy


```bash

 $ kubectl apply -f ../oauth2-proxy/
 $ kubectl apply -f ../approval-task/k8s/pproval-task/k8s/v1beta1/

```
