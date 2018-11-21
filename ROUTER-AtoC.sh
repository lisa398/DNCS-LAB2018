export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
ip addr add 192.168.10.254/24 dev eth1.10
ip addr add 192.168.20.254/24 dev eth1.20
ip addr add 192.168.255.253/30 dev eth2
ip link set eth1 up
ip link set eth1.10 up
ip link set eth1.20 up
ip link set eth2 up
sysctl net.ipv4.ip_forward=1
