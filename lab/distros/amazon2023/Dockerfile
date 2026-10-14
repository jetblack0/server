FROM amazonlinux:2023

# rootfiles gives root its default dotfiles, as on a real AMI.
RUN dnf -y -q install ansible-core git sudo shadow-utils rootfiles \
 && dnf -q clean all

# A normal user with passwordless sudo.
RUN useradd -m -u 1000 dev \
 && echo 'dev ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/dev \
 && chmod 0440 /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev
CMD ["sleep", "infinity"]
