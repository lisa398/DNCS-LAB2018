export DEBIAN_FRONTEND=noninteractive

#Install docker and run nginx inside
apt-get update
apt-get install -y tcpdump apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes

#PROVISIONING
vagrant provision host-2-c

# Set-up the ip add
ip addr add 172.27.3.253/30 dev eth1
ip link set eth1 up
ip route replace 172.16.0.0/12 via 172.27.3.254

# Create a sample index page
mkdir -p /var/www
chmod +r /var/www
echo "<!DOCTYPE html>
<html>
<head>
<title>Home - hostc</title>
</head>
<body>
This is the hostc website homepage
</body>
</html>" > /var/www/index.html
