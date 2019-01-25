export DEBIAN_FRONTEND=noninteractive
apt-get install -y curl apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
vagrant provision host-c

# Set-up the ip add
ip addr add 172.27.3.253/30 dev eth1
ip link set eth1 up
ip route replace 172.16.0.0/12 via 172.27.3.254
