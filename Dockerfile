FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    wget \
    gzip \
    sudo \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*
ENV USER=container
ENV HOME=/home/container
ENV SERVER_MEMORY=2048
ENV SERVER_PORT=2222
RUN adduser --disabled-password --home /home/container container \
    && echo "container ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR $HOME
RUN wget -O ubuntu-22.qcow2.gz "https://github.com/ma4z-sys/LumenVM/releases/download/ubuntu-22/ubuntu-22.qcow2.gz" \
    && gunzip ubuntu-22.qcow2.gz
VOLUME ["$HOME/data"]
EXPOSE $SERVER_PORT
CMD ["sh", "-c", "qemu-system-x86_64 \
    -enable-kvm -cpu host \
    -hda ubuntu-22.qcow2 \
    -m ${SERVER_MEMORY} \
    -net user,hostfwd=tcp::${SERVER_PORT}-:22 \
    -net nic \
    -nographic"]
