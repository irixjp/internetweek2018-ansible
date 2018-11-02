FROM centos:7
ENV container docker

RUN yum install -y epel-release && \
    yum install -y git python-pip vim&& \
    pip install -U pip  && \
    pip install -U setuptools && \
    pip install ansible boto boto3 passlib && \
    yum clean all
