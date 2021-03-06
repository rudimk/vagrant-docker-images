FROM ubuntu:focal
LABEL MAINTAINER="Rudi MK <rudimk.cloud@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Install packages needed for SSH and interactive OS
RUN apt-get update && \
    yes | unminimize && \
    apt-get -y install \
        openssh-server \
        gnupg2 \
        passwd \
        sudo \
        man-db \
        curl \
        wget \
        net-tools \
        dnsutils \
        gcc \
        g++ \
        build-essential \
        binutils \
        make \
        telnet \
        git \
        unzip \
        bash-completion \
        locales \
        vim \
        vim-tiny && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable systemd (from Matthew Warman's mcwarman/vagrant-provider)
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Enable ssh for vagrant
RUN systemctl enable ssh.service; 
EXPOSE 22

# Create the vagrant user
RUN useradd -m -G sudo -s /bin/bash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant && \
    chmod 440 /etc/sudoers.d/vagrant

# Establish ssh keys for vagrant
RUN mkdir -p /home/vagrant/.ssh; \
    chmod 700 /home/vagrant/.ssh
ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys; \
    chown -R vagrant:vagrant /home/vagrant/.ssh

# Install locales
RUN locale-gen en_US en_US.UTF-8

# Install nvm
RUN git clone https://github.com/nvm-sh/nvm.git /home/vagrant/.nvm
WORKDIR /home/vagrant/.nvm
RUN git checkout v0.39.1
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/vagrant/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/vagrant/.bashrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/vagrant/.bashrc
RUN chown -R vagrant:vagrant /home/vagrant/.nvm

# Configure git
RUN git config --global user.email "rudimk.cloud@gmail.com"
RUN git config --global user.name "Rudi MK"
RUN echo 'source /usr/share/bash-completion/completions/git' >> /home/vagrant/.bashrc

# Run the init daemon
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]