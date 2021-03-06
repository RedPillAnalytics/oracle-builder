FROM oraclelinux:7-slim AS base

RUN yum update -y && \
    yum install -y oracle-database-preinstall-19c wget vim-minimal sudo java-11-openjdk-devel which && \
    yum clean all

COPY .bashrc /home/oracle/

USER oracle

ENTRYPOINT ["bash"]
