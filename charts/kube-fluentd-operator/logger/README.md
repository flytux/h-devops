# Install

- multiline exeption filter
- elasticserch sink
- s3 sink
- empty dir log shipping

```bash
 k create configmap fluentd-config -n ns-app-core-dev --from-file=fluent.conf=app-core-dev.conf 
```
