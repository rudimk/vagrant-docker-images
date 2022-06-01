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
        python3-dev \
        python3-distutils \
        python3-apt \
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

# Install kubectl and helm
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl -OL https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz
RUN tar -zxvf helm-v3.7.0-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm
RUN rm -r kubectl && rm -r linux-amd64

# Install pip3 and pipenv3
RUN curl -LO https://bootstrap.pypa.io/get-pip.py
RUN curl -LO https://raw.githubusercontent.com/pypa/pipenv/master/get-pipenv.py
RUN python3 get-pip.py && python3 get-pipenv.py

# Install CLIs for AWS, GCP, and DO
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt update && apt install google-cloud-cli
RUN curl -LO https://github.com/digitalocean/doctl/releases/download/v1.71.0/doctl-1.71.0-linux-amd64.tar.gz
RUN tar -xf doctl-1.71.0-linux-amd64.tar.gz
RUN mv doctl /usr/local/bin

# Install the Porter CLI
RUN curl -fsSL https://install.porter.run | bash -

# Configure git
RUN touch /home/vagrant/.gitconfig
RUN echo '[user]' >> /home/vagrant/.gitconfig
RUN echo 'name = Rudi MK' >> /home/vagrant/.gitconfig
RUN echo 'email = rudimk.cloud@gmail.com' >> /home/vagrant/.gitconfig
RUN echo 'source /usr/share/bash-completion/completions/git' >> /home/vagrant/.bashrc

# Run the init daemon
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
