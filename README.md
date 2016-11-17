# Fun with linking and IPTables
Least Requied Privledges shouldn't just apply to users, but instead to everything. Although this might be overkill for a realworld application, we're going to link some containers add micro-services to control permissions on a node. The first container is a beloved docker training app. The second is an iptables rules set. 
Containers leverage namespaces. Networking has it's own namespace. So we can create iptables rules that only exist for that name space. Those rules won't cuase problems with other namespaces, or  the global namespace ( that may be a very Solaris Zones way of saying it). However, to futz with iptables rules in Docker, we need elevate permissions. In the most stringent applications of LRP, the application  container does't require the elavated, NET_ADMIN, priviledge. Moreover, with ECS it's either it either privledge mode or not priviledged mode for NET_ADMIN.  Thus, we want a separate serivce handling the inbound traffic.
## NOTE: The IPTables conatiner is a long ways from 12Factor.
The container in this state is a long ways from a 12 Facter App. The iptables rules need variablization (It's a word!!!). 

## Create the bridge
```
sudo docker network create --subnet=172.18.0.0/24 -d bridge customerA
```
This is straight docker 101 v2. The old --link concept, which precedes me, is depricated. Instead we create a custom network. The network should probably be a /29. We use three IPs for network stuff and then the two containers.

## Starting IPtables container
```
sudo docker run -d --cap-add NET_ADMIN --read-only --net customerA --ip 172.18.0.33 --name iptables  -p 0.0.0.0:5000:5000 -ti iptables:v1 /usr/sbin/iptablessript.sh
```
IPTables doesn't run an App. It just runs runs iptables rules. The container at docker hub was created with the Dockerfile at github. The iptablesscript does run tcpdump as something to hold docker open and to get somekind of logging.
cap-add and current linking mechanisms (--net customerA) are well documented. I'm not going any further on those. However, note the defined IP. It's important for IPTables to work. This IP must match the output of the iptables script for SNAT.
## Start the App
```
sudo docker run -d --net customerA --ip 172.18.0.23 --name app -t -i training/webapp app
```
Here we start the app. This defined IP must match the output of the iptables script for DNAT. Also, note that the app doesn't listen outside of the container. 


