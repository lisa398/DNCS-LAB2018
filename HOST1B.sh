export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y docker-ce
apt install -y curl --assume-yes
ip addr add 192.168.20.1/27 dev eth1
ip link set eth1 up
ip route add 192.168.0.0/16 via 192.168.20.30
