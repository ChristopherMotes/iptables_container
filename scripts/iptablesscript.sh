#!/bin/bash
iptables -X
iptables -t nat -A PREROUTING -p tcp --dport 5000 -j DNAT --to-destination 172.18.0.23:5000
iptables -t nat -A POSTROUTING -p tcp -d 172.18.0.23 --dport 5000 -j SNAT --to-source 172.18.0.33
tcpdump port 5000
