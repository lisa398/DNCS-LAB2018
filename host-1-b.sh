export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y docker-ce
apt install -y curl --assume-yes

#PROVISIONING
vagrant provision host-1-b

# Set-up the ip add
ip addr add 172.27.2.225/27 dev eth1
ip link set eth1 up
ip route replace 172.16.0.0/12 via 172.27.2.254
