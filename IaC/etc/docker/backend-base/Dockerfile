FROM docker.io/eclipse-temurin:11.0.19_7-jre-alpine
LABEL authors="devops"

# USER
ARG USER_NAME=swadmin
ARG GROUP_NAME=hroco
ARG USER_UID=2003
ARG USER_GID=2000
#RUN addgroup hroco --gid $USER_GID && \
#    adduser --disabled-password --gecos "" --uid $USER_UID -- ingroup hroco $USER_NAME
RUN mkdir -p $USER_NAME \
  && chown ${USER_UID}:${USER_GID} $USER_NAME \
  && addgroup -g ${USER_GID} ${GROUP_NAME} \
  && adduser -h "$USER_NAME" -u ${USER_UID} -G ${GROUP_NAME} -s /bin/bash -D ${USER_NAME}

RUN echo "$USER_NAME:passwd12!@" | chpasswd


# SCOUTER
RUN mkdir -p /app/scouter/agent.host/logs
RUN chown -R 2003:2000 /app/scouter/agent.host
RUN chmod -R 775 /app/scouter/agent.host

COPY --chown=2003:2000 scouter.host.jar /app/scouter/agent.host
COPY --chown=2003:2000 host.sh /app/scouter/agent.host
COPY --chown=2003:2000 stop.sh /app/scouter/agent.host

RUN chmod -R 775 /app/scouter/agent.host/scouter.host.jar
RUN chmod -R 775 /app/scouter/agent.host/host.sh
RUN chmod -R 775 /app/scouter/agent.host/stop.sh


# PETRA
RUN apk update && \
    apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    apk add --no-cache libc6-compat && \
    apk add --no-cache gcompat && \
    apk add --no-cache libnsl && \
    apk add --no-cache libstdc++6

RUN ln -s /usr/lib/libnsl.so.3.0.0 /usr/lib/libnsl.so.1
RUN ln -s /usr/lib/gcc/x86_64-alpine-linux-musl/6.4.0/libstdc++.so.6  /usr/lib/libstdc++.so.6
RUN mkdir -p /app/petra/log

RUN chown -R 2003:2000 /app/petra
RUN chmod -R 775 /app/petra

COPY --chown=2003:2000 libpcjapi.so /usr/lib
COPY --chown=2003:2000 petra_cipher_api.conf /app/petra
RUN chmod -R 755 /usr/lib/libpcjapi.so


# ENV
ENV TZ=Asia/Seoul


# RUN
CMD ["jshell"]