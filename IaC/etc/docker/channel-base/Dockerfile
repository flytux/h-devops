FROM docker.io/tomcat:9.0.75-jre11
LABEL authors="devops"

# USER
ARG USER_NAME=swadmin
ARG GROUP_NAME=hroco
ARG USER_UID=2003
ARG USER_GID=2000

RUN groupadd -g 2000 ${GROUP_NAME}
RUN useradd -r -u 2003 -g 2000 ${USER_NAME}


# SCOUTER
RUN mkdir -p /usr/local/scouter/agent.host/logs
RUN chown -R 2002:2000 /usr/local/scouter/agent.host
RUN chmod -R 775 /usr/local/scouter/agent.host

COPY --chown=2003:2000 scouter.host.jar /usr/local/scouter/agent.host
COPY --chown=2003:2000 host.sh /usr/local/scouter/agent.host
COPY --chown=2003:2000 stop.sh /usr/local/scouter/agent.host

RUN chmod -R 775 /usr/local/scouter/agent.host/scouter.host.jar
RUN chmod -R 775 /usr/local/scouter/agent.host/host.sh
RUN chmod -R 775 /usr/local/scouter/agent.host/stop.sh

# PETRA
RUN apt-get update && \
    apt-get install -y libcrypt-dev

RUN mkdir -p /usr/local/petra/log

COPY server.xml /usr/local/tomcat/conf
COPY setenv.sh /usr/local/tomcat/bin

RUN chown -R 2003:2000 /usr/local/petra
RUN chmod -R 775 /usr/local/petra

COPY --chown=2003:2000 libpcjapi.so /usr/lib
COPY --chown=2003:2000 petra_cipher_api.conf /usr/local/petra
RUN chmod -R 755 /usr/lib/libpcjapi.so


# EVN
ENV TZ=Asia/Seoul


# RUN
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]