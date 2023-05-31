FROM docker.io/alpine

RUN apk add --no-cache openssh git sudo tmux vim bash zsh curl wget coreutils util-linux tzdata shadow iputils \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

COPY sshd_config /etc/ssh/sshd_config
COPY startup.sh /etc/startup.sh

RUN cd /opt && curl dotfiles.cn | bash -s - -l -u root -x DFS_TRUST=1 \
  && sed -i 's?root:x:0:0:root:/root:/bin/ash?root:x:0:0:root:/root:/bin/zsh?' /etc/passwd

EXPOSE 22
ENTRYPOINT ["/etc/startup.sh"]
