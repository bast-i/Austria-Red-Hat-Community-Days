FROM ubi9/ubi:latest

RUN subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms &&\
    dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y &&\
    dnf search hugo