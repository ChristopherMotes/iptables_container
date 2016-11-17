# Fun with linking and IPTables
sudo docker network create --subnet=172.18.0.0/24 -d bridge customerA
sudo docker run -d --cap-add NET_ADMIN --net customerA --ip 172.18.0.33 --name iptables  -p 0.0.0.0:5000:5000 -ti iptables:v1 /usr/sbin/iptablessript.sh
sudo docker run -d --net customerA --ip 172.18.0.23 --name app -t -i training/webapp app


