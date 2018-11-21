export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
ip addr add 192.168.30.254/24 dev eth1
ip addr add 192.168.255.254/30 dev eth2
ip link set eth1 up
ip link set eth2 up
sysctl net.ipv4.ip_forward=1
