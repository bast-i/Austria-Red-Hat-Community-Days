FROM ubi9/ubi:latest

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y &&\
    /usr/bin/crb enable &&\
    dnf search hugo