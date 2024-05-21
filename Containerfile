FROM ubi9/ubi:latest

RUN /usr/bin/crb &&\
    dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y &&\
    dnf search hugo