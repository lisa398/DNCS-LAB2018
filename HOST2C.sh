export DEBIAN_FRONTEND=noninteractive
apt-get install -y curl apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
ip addr add 192.168.30.1/24 dev eth1
ip link set eth1 up
