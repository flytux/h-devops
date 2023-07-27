FROM maven:3.8.3-jdk-11-slim

RUN apt-get update && apt-get install -y net-tools iproute2 dnsutils iputils-ping openssh-server zsh git vim tmux jq netcat wget unzip

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k

RUN echo 'source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
RUN echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc
RUN echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>~/.zshrc

COPY ncloud /root/.ncloud
COPY zshrc /root/zshrc
COPY bin /usr/local/bin/

RUN cat /root/zshrc >> ~/.zshrc
RUN rm -rf /var/librapt/lists/*

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'root:1' | chpasswd
RUN ncp-iam-authenticator update-kubeconfig --region FKR --clusterUuid 8faad694-ac90-4616-881d-9d1d893f1112

WORKDIR /root

ENTRYPOINT ["/usr/bin/zsh"]
