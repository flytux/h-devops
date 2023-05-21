** Build approval image with mvn plugin without public js, css file**

```bash

$   mvn clean package -Dquarkus.container-image.push=true \\n
        -Dquarkus.container-image.registry=tbd5d1uh.private-ncr.fin-ntruss.com \\n
        -Dquarkus.container-image.username=959DEFE31E7314F09904 \\n
        -Dquarkus.container-image.password=AC2BE61635E4FA44FD0CF618B4133AE22885AB92 \\n
        -Dquarkus.jib.base-jvm-image=adoptopenjdk:jdk
```

