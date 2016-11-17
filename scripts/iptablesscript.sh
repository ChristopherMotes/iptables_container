#!/bin/bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
iptables -X
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -A -p tcp -s 172.18.0.23 -j ACCEPT
iptables -A OUTPUT -A -p tcp -d 172.18.0.23 -j ACCEPT
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 5000 -j DNAT --to-destination 172.18.0.23:5000
iptables -t nat -A POSTROUTING -p tcp -d 172.18.0.23 --dport 5000 -j SNAT --to-source 172.18.0.33
tcpdump port 5000
