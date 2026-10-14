FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
 && apt-get install -y -qq --no-install-recommends \
      ansible-core git sudo ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN userdel -r ubuntu 2>/dev/null; \
    useradd -m -u 1000 dev \
 && echo 'dev ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/dev \
 && chmod 0440 /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev
CMD ["sleep", "infinity"]
