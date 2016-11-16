FROM centos
MAINTAINER Christopher Motes "motescj@aim.com"

RUN yum -y -q install iptables tcpdump iproute
COPY scripts/iptablesscript.sh /usr/sbin/iptablessript.sh
