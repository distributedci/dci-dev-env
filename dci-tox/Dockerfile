FROM quay.io/centos/centos:stream8

LABEL name="DCI TOX" version="0.1.0"
LABEL maintainer="DCI Team <distributed-ci@redhat.com>"

COPY . /opt/dci-tox

WORKDIR /opt/dci-tox

RUN dnf -y update && \
    dnf -y install epel-release && \
    dnf -y install python3-pip python3-setuptools python3-wheel && \
    dnf -y install python2-pip python2-setuptools python2-wheel && \
    dnf -y install python3-devel python2-devel gcc postgresql-devel && \
    dnf -y install centos-release-ansible-29 ansible && \
    pip3 --no-cache-dir install -r requirements.txt && \
    dnf clean all

ENV DISABLE_DB_START 1
