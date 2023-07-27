FROM tomcat:8-jre8

COPY /build/pinpoint-quickstart-testapp.war quickstart.war

RUN rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps \
    && apt-get update \
    && apt-get install --no-install-recommends -y unzip\
    && unzip quickstart.war -d /usr/local/tomcat/webapps/ROOT \
    && rm -rf quickstart.war

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-2.5.2}

ARG INSTALL_URL=https://github.com/pinpoint-apm/pinpoint/releases/download/v${PINPOINT_VERSION}/pinpoint-agent-${PINPOINT_VERSION}.tar.gz

COPY build/scripts/configure-agent.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/configure-agent.sh \
    && mkdir -p /pinpoint-agent \
    && chmod -R o+x /pinpoint-agent \
    && curl -SL ${INSTALL_URL} -o pinpoint-agent.tar.gz \
    && gunzip pinpoint-agent.tar.gz \
    && tar -xf pinpoint-agent.tar --strip 1 -C /pinpoint-agent \
    && rm pinpoint-agent.tar \
    && /usr/local/bin/configure-agent.sh

CMD [ "catalina.sh", "run" ]
