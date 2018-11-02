FROM centos:7
ENV container docker

RUN yum install -y epel-release && \
    yum install -y git python-pip && \
    pip install -U setup pip vim && \
    pip install -U pip && \
    pip install -U setup && \
    pip install -U setuptools && \
    pip install ansible boto boto3 passlib && \
    yum clean all
