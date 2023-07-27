FROM docker.io/eclipse-temurin:11.0.19_7-jdk-alpine
LABEL authors="devops"

# USER
ARG USER_NAME=swadmin
ARG GROUP_NAME=hroco
ARG USER_UID=2003
ARG USER_GID=2000

RUN mkdir -p $USER_NAME \
  && chown ${USER_UID}:${USER_GID} $USER_NAME \
  && addgroup -g ${USER_GID} ${GROUP_NAME} \
  && adduser -h "$USER_NAME" -u ${USER_UID} -G ${GROUP_NAME} -s /bin/bash -D ${USER_NAME}

#ARG SCOUTER_VERSION=2.20.0
ARG SCOUTER_VERSION=2.17.1
ARG INSTALL_URL=https://github.com/scouter-project/scouter/releases/download/v${SCOUTER_VERSION}/scouter-all-${SCOUTER_VERSION}.tar.gz

WORKDIR /home
RUN apk add -U tzdata wget unzip
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN wget ${INSTALL_URL}
RUN tar xvf scouter-all-${SCOUTER_VERSION}.tar.gz
RUN mv scouter/server ./scouter-server
RUN cp scouter/webapp/scouter-webapp-${SCOUTER_VERSION}.jar ./scouter-server/lib
RUN cp scouter/webapp/lib/*.jar ./scouter-server/lib
RUN rm -rf scouter-all-${SCOUTER_VERSION}.tar.gz scouter

COPY startup.sh scouter-server/startup.sh

RUN ls -lat scouter-server

#RUN chown -R 2002:2000 scouter-server
RUN chmod 775 -R scouter-server

EXPOSE 6180/tcp
EXPOSE 6188/tcp
EXPOSE 6100/tcp
EXPOSE 6100/udp

WORKDIR /home/scouter-server

ENTRYPOINT ["/home/scouter-server/startup.sh"]