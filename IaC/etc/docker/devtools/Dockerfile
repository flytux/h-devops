FROM ubuntu:20.04
LABEL authors="devops"

ARG UID=1001
ARG GID=1001
ARG UNAME=devops
ARG DEBIAN_FRONTEND=noninteractive

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

ENV TF_VERSION 1.4.6
ENV ANSIBLE_VERSION 2.13.0
ENV PK_VERSION 1.9.1
ENV NCP_CLI_VERSION 1.1.14_20230525
ENV AWS_CLI_VERSION 1.15.85

# devops access info
ENV ACCESS_KEY_ID B8706A69B7E41CE978AB
ENV SECRET_ACCESS_KEY 7C48BD41C67993AD8B693A6B335EFB6E27921AA4

RUN useradd --uid ${UID} --create-home --shell /bin/bash -G sudo,root ${UNAME}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# built-in
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    python3 \
    python3-pip \
    tree \
    original-awk \
    jq \
    net-tools \
    nmap \
    git \
    unzip \
    bash \
    bash-completion \
    vim \
#    gcc \
#    nginx \
    && apt-get clean all

RUN mkdir -p /home/${UNAME}/base

# terraform install
WORKDIR /home/${UNAME}/base
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
RUN unzip -o terraform_${TF_VERSION}_linux_amd64.zip
RUN mv terraform /usr/local/bin/
RUN terraform --version

# ansible install
RUN python3 -m pip install ansible
RUN ansible --version

# packer install
RUN wget https://releases.hashicorp.com/packer/${PK_VERSION}/packer_${PK_VERSION}_linux_amd64.zip
RUN unzip -o packer_${PK_VERSION}_linux_amd64.zip
RUN mv packer /usr/local/bin/
RUN packer --version

# ncp cli intsall
RUN wget https://www.fin-ncloud.com/api/support/download/files/cli/FIN_CLI_${NCP_CLI_VERSION}.zip
RUN unzip -o FIN_CLI_${NCP_CLI_VERSION}.zip
RUN mkdir -p /home/${UNAME}/ncp
RUN cp -r FIN_CLI_${NCP_CLI_VERSION}/cli_linux/* /home/${UNAME}/ncp/
#COPY FIN_CLI_${NCP_CLI_VERSION}/cli_linux /home/${UNAME}/

#RUN echo "[DEFAULT]\n" \
#    "ncloud_access_key_id = "${ACCESS_KEY_ID}\n \
#    "ncloud_secret_access_key = "${SECRET_ACCESS_KEY}\n \
#    "ncloud_api_url = https://fin-ncloud.apigw.fin-ntruss.com\n" \ > ./configure
#COPY /home/$UNAME/base/FIN_CLI_${NCP_CLI_VERSION}/configure /home/$UNAME/.ncloud
RUN mkdir -p /home/${UNAME}/.ncloud
COPY ./configure /home/${UNAME}/.ncloud
WORKDIR /home/${UNAME}/ncp
RUN ./ncloud vserver getZoneList --regionCode FKR

# aws object storage cli install
RUN mkdir -p /home/${UNAME}/.aws
RUN pip install awscli==${AWS_CLI_VERSION}
RUN aws configure set aws_access_key_id ${ACCESS_KEY_ID} --profile default \
    && aws configure set aws_secret_access_key ${SECRET_ACCESS_KEY} \
    && aws configure set region kr-standard \
    && aws configure set output json
RUN aws --endpoint-url=https://kr.object.fin-ncloudstorage.com s3api list-buckets

RUN echo "export HISTCONTROL=ignoredups:erasedups" >> ~/.bashrc
RUN echo "export HISTSIZE=10000" >> ~/.bashrc
RUN echo "export HISTFILESIZE=10000" >> ~/.bashrc
RUN echo "shopt -s histappend" >> ~/.bashrc

WORKDIR /home/${UNAME}

CMD ["/bin/bash"]