export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y docker-ce
ip addr add 192.168.20.1/27 dev eth1
ip link set eth1 up
ip route replace default via 192.168.20.30 dev eth1
