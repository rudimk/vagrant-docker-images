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

# Install Golang 1.15.16
RUN curl -OL https://go.dev/dl/go1.17.8.linux-amd64.tar.gz
RUN tar -C /usr/local -xvf go1.17.8.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc

# Install tfenv for installing multiple versions of Terraform.
RUN git clone https://github.com/tfutils/tfenv.git /home/vagrant/.tfenv
RUN echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> /home/vagrant/.bashrc
RUN chown -R vagrant:vagrant /home/vagrant/.tfenv
RUN ln -s ~/.tfenv/bin/* /usr/local/bin/

# Install kubectl and helm
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl -OL https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz
RUN tar -zxvf helm-v3.7.0-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm
RUN rm -r kubectl && rm -r linux-amd64

# Configure git
RUN touch /home/vagrant/.gitconfig
RUN echo '[user]' >> /home/vagrant/.gitconfig
RUN echo 'name = Rudi MK' >> /home/vagrant/.gitconfig
RUN echo 'email = rudimk.cloud@gmail.com' >> /home/vagrant/.gitconfig
RUN echo 'source /usr/share/bash-completion/completions/git' >> /home/vagrant/.bashrc

# Run the init daemon
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]