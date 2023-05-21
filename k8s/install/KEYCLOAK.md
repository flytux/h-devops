# KEYCLOAK
**********

Install Keycloak
================
```bash
# Create Tls Secret file
kubectl create ns keycloak
kubectl -n keycloak create secret generic tls-secret \
    --from-file=tls.crt=/Users/kihoonyang/Desktop/documents/Project/2023/hro/hro_devops/cert/keycloak.herosonsa.co.kr/merged-crt.crt \
    --from-file=tls.key=/Users/kihoonyang/Desktop/documents/Project/2023/hro/hro_devops/cert/keycloak.herosonsa.co.kr/private.key
```
```bash
## installed StatefuleSet
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install keycloak bitnami/keycloak -f hro-values.yaml \
  --namespace keycloak --create-namespace
```

Set DNS Record
==============
* Add Record
    * host : keycloak
    * record type : LB VPC
    * value : k8s ingress
* Deploy


Connect Keycloak
================
* URL : keycloak.herosonsa.co.kr
* Admin Account
    * Initial ID : user ( set by helm value as `auth.adminUser`)
    * Initial PW
      ```bash
      kubectl get secret keycloak -n keycloak -ojsonpath='{.data.admin-password}' | base64 --decode ; echo
      #G2F763u36K
      ```


Create Realm
============
* Realm name : hro-devops
* Enabled : on


[GITLAB] Create Clients
=======================
* Create client
    * General Settings
        * Client type : `SAML`
        * Client ID : gitlab
    * Login Settings
        * Root URL : https://gitlab.herosonsa.co.kr/
        * Vaild redirect URIs : https://gitlab.herosonsa.co.kr/users/auth/saml/callback
        * IDP-Initated SSO URL name : gitlab.herosonsa.co.kr
        * Master SAML Processing URL : https://gitlab.herosonsa.co.kr/users/auth/saml/callback
        * Advanced
            * Fine Grain SAML Endpoint Configuration
                * Assertion Consumer Service POST Binding URL : https://gitlab.herosonsa.co.kr/users/auth/saml/callback


[GITLAB] Create Realm roles
===========================
* Role Name : gitlab:external


[GITLAB] Create Client scope
============================
* Name : gitlab
* Type : Default
* Protocol : `SAML`
* Mappers

  | Mapper type   | Name       | Property  | Friendly Name | SAML Attribute Name | SAML Attribute NameFormat | ETC |
    |---------------|------------|-----------|---------------|---------------------| --------------------------|--- |
  | User Property | first_name | FirstName | First Name    | first_name          |basic||
  | User Property | last_name  | LastName  | Last Name     | last_name           |basic||
  | User Property | username   | Username  | username      | username            |basic||
  | User Property | email      | Email     | Email         | email               |basic||
  | Role list     | roles      | roles     | Roles         | -                   |basic|Single Role Attribute:On|

[GITLAB] Add Client Scope
=========================
* Client > gitlab > Client scopes > Add clent scope > `gitlab` > add


[GITLAB] Config Certificate
=========================
* Open link : https://keycloak.herosonsa.co.kr/realms/hro-devops/protocol/saml/descriptor
* Copy tag value
```xml
<ds:X509Certificate>MIICnTCCAYUCBgF/UnSqfzANBg....</ds:X509Certificate>
```
* Create gitlab-sso.pem file
```
-----BEGIN CERTIFICATE-----
MIICnTCCAYUCBgF/UnSqfzANBg<OMIT_SECRET>
-----END CERTIFICATE-----
```
* Fingerprints
```bash
openssl x509 -sha1 -fingerprint -noout -in gitlab-sso.pem
SHA1 Fingerprint=35:0E:D7:8B:6E:B0:A1:EB:D2:CF:36:B9:19:02:99:9A:BA:B4:BB:DD
```
* SAML.yaml
```yaml saml.yaml
name: 'saml'
label: 'keycloak login'
groups_attribute: 'roles'
external_groups: ['gitlab']
args:
  assertion_consumer_service_url: 'https://gitlab.herosonsa.co.kr/users/auth/saml/callback'
  idp_cert_fingerprint: '35:0E:D7:8B:6E:B0:A1:EB:D2:CF:36:B9:19:02:99:9A:BA:B4:BB:DD'
  idp_sso_target_url: 'https://keycloak.herosonsa.co.kr/realms/hro-devops/protocol/saml/clients/gitlab.herosonsa.co.kr'
  issuer: 'gitlab'
  name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'
  attribute_statements:
    email: ['email']
    name: ['first_name']
    username: ['username']
```
* Create secret
```bash
kubectl create secret generic -n gitlab-system gitlab-saml --from-file=provider=saml.yaml
```

[ARGOCD] Create Clients
=======================
> reference : https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/keycloak/
* Create client
    * General Settings
        * Client type : `OpenID Connect`
        * Client ID : argocd
    * Capability config
        * Client authentication : On
    * Login Settings
        * Root URL : https://argocd.herosonsa.co.kr/
        * Vaild redirect URIs : *
    * Credentials
        * Client secret : dLRO6zHnR26SKRarTxhW1SPjrSI1bpnG
* Create Client scope
    * Name : groups
    * Type : Default
    * Protocal : OpenID Connect
    * Mappers
        * Mapper type : Group Membership
        * Name : groups
        * Token Claim Name : groups
        * Add to ID token : On
        * Add to access token : On
        * Add to userinfo : On
* Add cluent scopes to argocd ( for `developer` group )
    * Client > arogocd > Client scopes > Add client scope > `groups` Add Default
* argocd-secret에 oidc client secret 값 추가
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
  namespace: argo-system
  labels:
    app.kubernetes.io/name: argocd-secret
    app.kubernetes.io/part-of: argocd
type: Opaque
data:
  admin.password: >-
    JDJhJDEwJE8zNWZhNDNnNkpHeE9HanFoY3psV3VuS0xKMGJ1Z0dHbTlmUDhHR25jN2pTdjMya3NtT0JX
  admin.passwordMtime: MjAyMy0wNC0xOFQxMzozMjo0M1o=
  # oidc client secret
  oidc.keycloak.clientSecret: ZExSTzZ6SG5SMjZTS1JhclR4aFcxU1BqclNJMWJwbkc=
  server.secretkey: V29qY2NyQ2p6eWtCUDdpbmFPVzc0WmhoUEEvaTB4RkJ4ck5iSUVFK2VTUT0=
  tls.crt: >-
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUdlVENDQkdHZ0F3SUJBZ0lSQUxESC84dUxtZytkejRoV1c0OVNPSmd3RFFZSktvWklodmNOQVFFTUJRQXcKU3pFTE1Ba0dBMVVFQmhNQ1FWUXhFREFPQmdOVkJBb1RCMXBsY205VFUwd3hLakFvQmdOVkJBTVRJVnBsY205VApVMHdnVWxOQklFUnZiV0ZwYmlCVFpXTjFjbVVnVTJsMFpTQkRRVEFlRncweU16QTBNVGd3TURBd01EQmFGdzB5Ck16QTNNVGN5TXpVNU5UbGFNQ0F4SGpBY0JnTlZCQU1URldGeVoyOWpaQzVvWld4c2J5MW9jbTh1YzJsMFpUQ0MKQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dFUEFEQ0NBUW9DZ2dFQkFKN3N6cGZHQ0tuTmEzWGIyeUovQWh0VQpqbjUySkdUamMwanlBbm9Nc1BkTW9sdTRFUmtxcmJRVUw0SkVYWUUxNGtWTmYxNWhSb3ZOVzdtRW5nYjJOaGtkCnoxVUMrWkJFM0JJUzFHQzJOaHlhNEJNbXZhU1dZc1VHQk51a2RVVUZ6VzhCeGtoSG1VYXdNV1M4Q2VsYjB4TDAKbjNGeFFwdWozNWgzRFpHQUNoT210TlNicGRpWmJLcFBOQVQxNUJZRnliMnRVaWN4dnhSWlp6SnArNjdCQkN3OAo2alRDMXArR3pkWHFndVk5dzRtNVVkcXJzbm05alVwVkVzUUxRc2pnS3VqSU85YWpvSEZzb1VUWmxYKzAxc3cyCmtwa0pjcjAweU9DTHRjcHpZaEgxSGlrbCthcU44dUtzREpZcXg4cmJGRHdFbnBCWEp2SlhhYk9vYk1uZTk0c0MKQXdFQUFhT0NBb0V3Z2dKOU1COEdBMVVkSXdRWU1CYUFGTWpaZUdpaTJSbG8xVDF5M2w4S1B0eTFob2FtTUIwRwpBMVVkRGdRV0JCU1F2VHRZd3dpY0dMbWgzK3Z1dVcxdE1ZWktLREFPQmdOVkhROEJBZjhFQkFNQ0JhQXdEQVlEClZSMFRBUUgvQkFJd0FEQWRCZ05WSFNVRUZqQVVCZ2dyQmdFRkJRY0RBUVlJS3dZQkJRVUhBd0l3U1FZRFZSMGcKQkVJd1FEQTBCZ3NyQmdFRUFiSXhBUUlDVGpBbE1DTUdDQ3NHQVFVRkJ3SUJGaGRvZEhSd2N6b3ZMM05sWTNScApaMjh1WTI5dEwwTlFVekFJQmdabmdRd0JBZ0V3Z1lnR0NDc0dBUVVGQndFQkJId3dlakJMQmdnckJnRUZCUWN3CkFvWS9hSFIwY0RvdkwzcGxjbTl6YzJ3dVkzSjBMbk5sWTNScFoyOHVZMjl0TDFwbGNtOVRVMHhTVTBGRWIyMWgKYVc1VFpXTjFjbVZUYVhSbFEwRXVZM0owTUNzR0NDc0dBUVVGQnpBQmhoOW9kSFJ3T2k4dmVtVnliM056YkM1dgpZM053TG5ObFkzUnBaMjh1WTI5dE1JSUJCQVlLS3dZQkJBSFdlUUlFQWdTQjlRU0I4Z0R3QUhZQXJmZSsrbnovCkVNaUxuVDJjSGo0WWFyUm5LVjNQc1F3a3lvV0dOT3ZjZ29vQUFBR0hsSnBOYkFBQUJBTUFSekJGQWlBZkdFZE8KajJMTXAvdFBEQXl2KzFPRC8wUUM3Q3B1Q2lNbllDajh5T0Y1MmdJaEFMRXNhVGdnRW02b3FLbnVJa0FOTWtJMwo4L0VocFFmNXB6ZmhrNkMyT3pxcUFIWUFlaktNVk5pM0xiWWc2ampnVWg3cGhCWndNaE9GVFR2U0s4RTZWNk5TCjYxSUFBQUdIbEpwTnlnQUFCQU1BUnpCRkFpRUF2eTNxZjV6VEJaclMzdC9DZE0vOTBkVHZQaUt2dXppTDF0anUKc2NqTlc5Y0NJQlF0NTlmbHJSalJOVmxhWGMraHdnWVExUlhtTDJpU2dZMXppaWNnREVoek1DQUdBMVVkRVFRWgpNQmVDRldGeVoyOWpaQzVvWld4c2J5MW9jbTh1YzJsMFpUQU5CZ2txaGtpRzl3MEJBUXdGQUFPQ0FnRUFkcGR6Ck83VVpaQ1J6UzkySGxKSkFiWk5WNllFWFg2ZnVlRGFmWEk2ZkUwZmdsbXFpT0todnh6V0JDQzZSaUlKN0l6UUwKeSsrWU5VaU1xL21YZ1VCRjRXRGoweXRYVTRObUd1Q2g1cnY4QlpGQy9mNkU4VDd2TFcwMlNkZEVMa2Z6YmJJUgpkRVlTT05OQUtLL0dJSnZEVUJyYi9ZWmp3NHRhOVp3bFV5TmVJcExvM2UrV2ljbk9sUzVKVnRTOGNqVEFyN014CmJBUFkzSHh1a2pHKzUyVlpmbnJWN0tKbzhXR3FaZDhPSkM2WWNZTjMyNGJEbHM1RHZGUVY0RFdVY3JRdVJYeUwKTk5wQlI2UDBsNUNnbmg3aTVpMjk3MWNmTVZSMm1STDFoUnpNNGIxdnljeG1CVWh6ZkhRQytKb0hDek9iVVdNZwpRcnhBWkh2NkdzR0drWGxOY1k1OHdISno5UWlZL2xhVkE5RFdyT1RtNlJhWnJWWkRJS3BXd1gwdGJZOXhGQXlTCngxVHdKWjNsV1M3U3ZTVjJMYk5kV09YcDZ0dGQxaFoxa1VlNmdjcXhqS2FISnJ4SEh5dlM3TSt6d3RWOFpDUlcKMnIvRFpRMUw0TlBkdm9vQjk1ekgveXE3b0Q2ZUVWTVE4dXByZlVtU3ZmaFJzWXdWK1F3Q3diaUtIaFYrMUxDeApDR2t2MFdnQ0FteGFjMm9aRUpBaWxUWWtiNWdjeHZFdFk1Vm9qcThESFZHS3pnYzFLQXh3eVFCN2Z3emQ4T1hSClV3NGF1ZTVCSDhYYmxBMkdJZEV4Ulg3QXlqYVdkUk00a2pxVGZGQXJYcHVIdDE5Q2dXVWJXWFBkNU85ajhuZTgKK2xxaUExSmE1QmFPbDFDZHd2MWtMRWtHMGJFM1JQeURHeStjdkpVPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCi0tLS0tQkVHSU4gQ0VSVElGSUNBVEUtLS0tLQpNSUlHMVRDQ0JMMmdBd0lCQWdJUWJGV3IyOUFIa3NlZEJ3ellFWjdXdnpBTkJna3Foa2lHOXcwQkFRd0ZBRENCCmlERUxNQWtHQTFVRUJoTUNWVk14RXpBUkJnTlZCQWdUQ2s1bGR5QktaWEp6WlhreEZEQVNCZ05WQkFjVEMwcGwKY25ObGVTQkRhWFI1TVI0d0hBWURWUVFLRXhWVWFHVWdWVk5GVWxSU1ZWTlVJRTVsZEhkdmNtc3hMakFzQmdOVgpCQU1USlZWVFJWSlVjblZ6ZENCU1UwRWdRMlZ5ZEdsbWFXTmhkR2x2YmlCQmRYUm9iM0pwZEhrd0hoY05NakF3Ck1UTXdNREF3TURBd1doY05NekF3TVRJNU1qTTFPVFU1V2pCTE1Rc3dDUVlEVlFRR0V3SkJWREVRTUE0R0ExVUUKQ2hNSFdtVnliMU5UVERFcU1DZ0dBMVVFQXhNaFdtVnliMU5UVENCU1UwRWdSRzl0WVdsdUlGTmxZM1Z5WlNCVAphWFJsSUVOQk1JSUNJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBZzhBTUlJQ0NnS0NBZ0VBaG1semZxTzFNZGdqCjRXM2RwQlBUVkJYMUF1dmNBeUcxZmwwZFVudy9NZXVlQ1d6UldUaGVaMzVMVm85MWtMSTNERFZhWktXK1RCQXMKSkJqRWJZbU13Y1dTVFdZQ2c1MzM0U0YwK2N0REFzRnhzWCtyVERoOWtTckcvNG1wNk9TaHViTGFFSVVKaVpvNAp0ODczVHVTZDBXajVEV3QzRHRwQUc4VDM1bC92K3hyTjh1YjhQU1NvWDVWa2d3K2pXZjRLUXROdlVGTERxOG1GCldoVW5QTDZqSEFBRFhwdnM0bFROWXdPdHg5eVF0YnB4d1N0N1FKWTErSUNybVJKQjZCdUtSdC9qZkRKRjlKc2MKUlFWbEhJeFFkS0FKbDdvYVZuWGdEa3F0azJxZGRkM2tDRFhkNzRndjgxM0c5MXo3Q2pzR3lKOTNvSklsTlMzVQpnRmJENlY1NEpNZ1ozclNtb3RZYno5OG9aeFg3TUtidENtMWFKL3EraFR2MllLMXlNeHJuZmNpZUttT1lCYkZECmhuVzVPNlJNQTcwM2RCSzkyajZYUk4yRXR0TGtRdXVqWmd5K2pYUkt0YVdNSWxrTmtXSm1PaUhtRXJRbmdIdnQKaU5rSWNqSnVtcTFkZEZYNGlhVEk0MGE2emd2SUJ0eEZlRHMyUmZjYUg3M2VyN2N0TlVVcWdRVDVyRmdKaE1tRgp4NzZyUWdCNU9aVWtvZGI1azJleDdQK0d1NEo4NmJTMTUwOTRVdVljVjA5aFZla25tVGg1RXg5Q0JLaXBMUzJXCjJ3S0Jha2YrYVZZbk5DVTZTMG5BU3F0MnhyWnBHQzF2N3Y2RGh1ZXB5eUp0bjNxU1YyUG9CaVU1U3FsK2FBUnAKd1VpYlFNR200NGdqeU5EcURsVnArU2hMUWxVSDl4OENBd0VBQWFPQ0FYVXdnZ0Z4TUI4R0ExVWRJd1FZTUJhQQpGRk41djFxcUswclBWSURoMkp2QW5mS3lBMmJMTUIwR0ExVWREZ1FXQkJUSTJYaG9vdGtaYU5VOWN0NWZDajdjCnRZYUdwakFPQmdOVkhROEJBZjhFQkFNQ0FZWXdFZ1lEVlIwVEFRSC9CQWd3QmdFQi93SUJBREFkQmdOVkhTVUUKRmpBVUJnZ3JCZ0VGQlFjREFRWUlLd1lCQlFVSEF3SXdJZ1lEVlIwZ0JCc3dHVEFOQmdzckJnRUVBYkl4QVFJQwpUakFJQmdabmdRd0JBZ0V3VUFZRFZSMGZCRWt3UnpCRm9FT2dRWVkvYUhSMGNEb3ZMMk55YkM1MWMyVnlkSEoxCmMzUXVZMjl0TDFWVFJWSlVjblZ6ZEZKVFFVTmxjblJwWm1sallYUnBiMjVCZFhSb2IzSnBkSGt1WTNKc01IWUcKQ0NzR0FRVUZCd0VCQkdvd2FEQS9CZ2dyQmdFRkJRY3dBb1l6YUhSMGNEb3ZMMk55ZEM1MWMyVnlkSEoxYzNRdQpZMjl0TDFWVFJWSlVjblZ6ZEZKVFFVRmtaRlJ5ZFhOMFEwRXVZM0owTUNVR0NDc0dBUVVGQnpBQmhobG9kSFJ3Ck9pOHZiMk56Y0M1MWMyVnlkSEoxYzNRdVkyOXRNQTBHQ1NxR1NJYjNEUUVCREFVQUE0SUNBUUFWRHdvSXpRRFYKZXJjVDBlWXFaakJOSjhWTld3VkZsUU90WkVScW41aVduRVZhTFpaZHp4bGJ2ejJGeDBFeFVOdVVFZ1lrSVZNNApZb2NLa0NRN2hPNW5vaWNvcS9EckVZSDVJdU5jdVcxSThKSlo5REx1QjFmWXZJSGxaMkpHNDZpTmJWS0EzeWdBCkV6ODZSdkRRbHQyQzQ5NHFxUFZJdFJqcno5WWxKRUdUMERydHR5QXBxMFlMRkR6ZitaMXBrTWhoN2MrN2ZYZUoKcW1JaGZKcGR1S2M4SEVRa1lRUVNoZW40MjZTM0gwSnJJQWJLY0JDaXlZRnVPaGZ5dnV3VkNGRGZGdnJqQURqZAo0algxdVFYZDE2MUl5RlJibTg5czJPajVvVTF3RFl6NXN4K2hvQ3VoNmxTcysvdVB1V29tSXEzeTFHREZOYWZXCitMc0hCVTE2bFFvNVEyeWgyNWxhUXNLUmd5UG1NcEhKOThlZG02eTJzSFVhYkFTbVJIeHZHaXV3d0UyNWFEVTAKMlNBZWVweUltSjJDekI4MFlHN1d4bHluSHFOaHBFN3hmQzdQelFsTGdtZkVIZFUrdEhGZVFhelJRbnJGa1cyVwprcVJHSXE3Y0tSbnl5cHZqUE1ramVpVjlsUmRBTTlmU0p2c0Izc3ZVdXUxY29JRzF4eEkxeWVnb0dNNHI1UVA0ClJHSVZ2WWFpSTc2QzBkam9TYlEvZGtJVVVYUXVCOEFMNWp5SDM0ZzNCWmFhWHl2cG1uVjRpbHBwTVhWQW5BWUcKT041MVdoSjZXMHhOZE5Kd3pZQVNaWUgrdG1DV0krTjYwR3YyTk5NR0h3TVo3ZTliWGd6VUNaSDVGYUJGREdSNQpTOVZXcUhCNzNRK095SVZ2SWJLWWNTYzJ3L2FTdUZLR1NBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: >-
    LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBbnV6T2w4WUlxYzFyZGR2YkluOENHMVNPZm5Za1pPTnpTUElDZWd5dzkweWlXN2dSCkdTcXR0QlF2Z2tSZGdUWGlSVTEvWG1GR2k4MWJ1WVNlQnZZMkdSM1BWUUw1a0VUY0VoTFVZTFkySEpyZ0V5YTkKcEpaaXhRWUUyNlIxUlFYTmJ3SEdTRWVaUnJBeFpMd0o2VnZURXZTZmNYRkNtNlBmbUhjTmtZQUtFNmEwMUp1bAoySmxzcWs4MEJQWGtGZ1hKdmExU0p6Ry9GRmxuTW1uN3JzRUVMRHpxTk1MV240Yk4xZXFDNWozRGlibFIycXV5CmViMk5TbFVTeEF0Q3lPQXE2TWc3MXFPZ2NXeWhSTm1WZjdUV3pEYVNtUWx5dlRUSTRJdTF5bk5pRWZVZUtTWDUKcW8zeTRxd01saXJIeXRzVVBBU2VrRmNtOGxkcHM2aHN5ZDczaXdJREFRQUJBb0lCQUZLZVhSQTkzVWNaQ1dKdAo5MC9Kb3ppK0RvM2pzU3ZacXBjamFQSTJJdEdOUDJKYklGaHEvWDUrZCt4S3lpbGY3OCtEYUZHU1ZIQmRRKy8vCjUzOUxBL2l1ckpoUFFab2traHU3T2psRXdJRENhdmJKenhEL05UMmowV2ExNmxrRm1UUzZRWEJWK0hMdEtlQnEKZU9TZDNlOGV5THphMm51N0I0UmxiK0pTSStydWoyMSs5dkZ2YmxWMWdocjFKaXUyQ3k5a29qVUJlY1ZCMmNkaAp3TE1ocGoxMVd0dzNIbUhndUF5RHYrY0dtZlhGaTcrbkJqM3ZSMGxZc05qemEwRTNYQWRZZ1dGbFdqV3BBb0kwCkNLM3lQSlROYUZQZlpJQU9lanZ1a3lya1BCR0VQTTJCV21NT1QrN1JTWGlDK1lOQ0I5Q2Ywd1Q2QkNuMTdwN1QKM2k4cVVXRUNnWUVBMHBVVmtvemJlL3cvSlpPaW9WRk1qek1hWitoWUg5dEtITFMxYkpkZUxLby9PWjNFbkptNApENTRpSHhXcUNSa016cnZtWmllWGhvKzAyNHJRNTA4RmVVY2dvaUtrYzZkZWhaYTFBR09OZkthUlFWM2lHSnZHCnJSbGlNQ2pDbG5icVFLaEhxTlJhMW92THgvckZmTENVY0czMllNN1RJUXlrRk50Vk4xQi9Eak1DZ1lFQXdUT08KLzZiRFZqOG9ldUZnOVRBa0tRMlduV2tnTzI2bTZoOTc1emttc0o5UVBFNnAvYW5JbU9FZVZNdkxYbjhxR3BQRgpvU2svQ2QxNXhkNzBGZHl3SS8wRkxHK2srd1k3alJvQ1RCYnlldVpvbE1XVDRYSWZYRGJuU1MydUNidVhMWjUxCkIvNVZlTmV2bHl2MTZCRXYvL055blhvKzVyYnUyajNvN0pEcmFVa0NnWUVBeDB0aEJ6bFgzNWR6QzlVVmJTYk0KRmhwL095ZWhmMFRDZHpodkd6NkdXaThsZHhuaElYUTV4azRhYk9ETDg2QkpocjQ5NXlCQlA1QngwZlVta0VNeApJdjQxM0R4ODl4ZkhWUmEwWnBIUkxjOVdXVTdJMUJGWmppa2Z6QVJIWks5V002c1BackRTNTRtV2FzVGljb2VMCmRId2RXTEZsRHpvdmI2M0VrSDBXUWhFQ2dZRUFpdVRSR2hPK2ZLT2RLM0laN1VzMXc5bkQvTmhWMXNRKzlUTzcKTk1qT2VzMmR0aTFyWWpTTVJQUWFoU1daeUE2dHF6dXZLYVJvY0dRcnBrZ1p2Qm5TKzV4cityMHNvMWFndTFrRwphOE5YZ1dsaHFBcSt2S1g1eTZhZzhlZ0lKWEVhUnk2U3ZqTm5LU0FPV1NTK2ZaN1ZuakZicGNEN3RZdXYvVy9pCm95ZXdSaGtDZ1lBcSt2bVhKVGRKNStaMDVGek4zdFMwMXdXVVVCR1crMldjQUdybFRFV0FhOWFPVXhpRkN1Z3kKNHVkZFE2Zy92cGRJdlVNREZkU0hVR3lUV0lFSEhhU1NkdlBpOVhwMGJZUml5Yjl5WmxjZkRMRzR5OTNEV2k3VQpNL2U4L0xUY1RwdnNSVk1oNlcrRzRubDJRU3U0REwyQks4TjdNOTVVK01VcU1WYTVRbS81ekE9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
```
* argocd-cm에 oidc.config 추가
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argo-system
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
data:
  url: https://argocd.herosonsa.co.kr
  oidc.config: |
    name: Keycloak
    issuer: https://keycloak.herosonsa.co.kr/realms/hro-devops
    clientID: argocd
    clientSecret: $oidc.keycloak.clientSecret
    requestedScopes: ["openid", "profile", "email", "groups"]
```
* argocd-rbac-cm configmap에 group명 추가
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argo-system
  labels:
    app.kubernetes.io/name: argocd-rbac-cm
    app.kubernetes.io/part-of: argocd
data:
  policy.csv: |
    g, developer, role:admin
```





Add User
========
* Groups
    * Create a group
        * Name : developer

* Users
    * Create a user
        * Required user actions : `Update Password`
        * Username : P9000999
        * Email : P9000999@herosonsa.co.kr
        * Email verified : No
        * First name : 어로
        * Last name : 히
        * Groups : `developer`
    * Credentials
        * Set password
        * Password : 1111
        * Password confirmation : 1111
        * Temporary : On


