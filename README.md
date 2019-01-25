# DNCS-LAB assigment

Design of Networks and Communication Systems  
A.Y. 2018/19  
University of Trento

## Table of contents

-   [Before starting](#before-starting)
-   [Assignment by Nicola Arnoldi](#assignment-by-nicola-arnoldi)
-   [Network map](#network-map)
-   [Network configuration](#network-configuration)
    -   [Subnets](#subnets)
    -   [VLANs](#vlans)
    -   [Interface-IP mapping](#interface-ip-mapping)
-   [Vagrant and devices configuration](#vagrant-and-devices-configuration)
    -   [router-1](#router-1)
        -   [Virtual machine configuration](#router-1--virtual-machine-configuration)
        -   [Provisioning script](#router-1--provisioning-script)
    -   [router-2](#router-2)
        -   [Virtual machine configuration](#router-2--virtual-machine-configuration)
        -   [Provisioning script](#router-2--provisioning-script)
    -   [switch](#switch)
        -   [Virtual machine configuration](#switch--virtual-machine-configuration)
        -   [Provisioning script](#switch--provisioning-script)
    -   [host-1-a](#host-1-a)
        -   [Virtual machine configuration](#host-1-a--virtual-machine-configuration)
        -   [Provisioning script](#host-1-a--provisioning-script)
    -   [host-1-b](#host-1-b)
        -   [Virtual machine configuration](#host-1-b--virtual-machine-configuration)
        -   [Provisioning script](#host-1-b--provisioning-script)
    -   [host-2-c](#host-2-c)
        -   [Virtual machine configuration](#host-2-c--virtual-machine-configuration)
        -   [Provisioning script](#host-2-c--provisioning-script)
-   [How-to](#how-to)

## Before starting

Do you know Vagrant? No? You must check [this](https://www.vagrantup.com/)!

## Assignment by Nicola Arnoldi

Based on the _Vagrantfile​_ and the provisioning scripts available at <https://github.com/dustnic/dncs-lab>, the candidate is required to design a working network in witch any host configured and attached to​ _router-1​_ (through _switch​_) can browse a website hosted on _host-2-c_.
Subnetting must be designed to meet the following requirements (no need to create more hosts than described in the _Vagrantfile_):

-   up to 130 hosts in the same subnet of​ _host-1-a_
-   up to 25 hosts in the same subnet of _host-1-b_
-   consume as few IP addresses as possible

## Network map

         +------------------------------------------------------------+
         |                                                        eth0|
     +---+---+                  +------------+                 +------+-----+
     |       |                  |            |                 |            |
     |       +------------------+  router-1  +-----------------+  router-2  |
     |   v   |              eth0|            |eth2         eth2|            |
     |   a   |                  +-----+------+                 +------+-----+
     |   g   |                        |eth1                       eth1|
     |   r   |                        |                               |
     |   a   |                        |                           eth1|
     |   n   |                        |eth1                     +-----+----+
     |   t   |             +----------+-----------+             |          |
     |       |             |                      |             |          |
     |   m   +-------------+        switch        |             | host-2-c |
     |   a   |         eth0|                      |             |          |
     |   n   |             +---+--------------+---+             |          |
     |   a   |                 |eth2      eth3|                 +-----+----+
     |   g   |                 |              |                   eth0|
     |   e   |                 |              |                       |
     |   m   |                 |eth1      eth1|                       |
     |   e   |           +-----+----+    +----+-----+                 |
     |   n   |           |          |    |          |                 |
     |   t   |           |          |    |          |                 |
     |       +-----------+ host-1-a |    | host-1-b |                 |
     |       |       eth0|          |    |          |                 |
     |       |           |          |    |          |                 |
     +--+-+--+           +----------+    +----+-----+                 |
        | |                               eth0|                       |
        | +-----------------------------------+                       |
        +-------------------------------------------------------------+

## Network configuration

### Subnets

As in class, I decided to set up 4 different subnets:

-   **A** for _host-1-a_, _router-1_ and other 128 hosts, so I used _/24_ as netmask with which you can address up to 2<sup>32-24</sup>-2=254 hosts

-   **B** for _host-1-b_, _router-1_ and other 23 hosts, so I used _/27_ as netmask with which you can address up to 2<sup>32-27</sup>-2=30 hosts

-   **C** for _host-2-c_ and _router-2_, so I used _/30_ as netmask with which you can address up to 2<sup>32-30</sup>-2=2 hosts

-   **D** for _router-1_ and _router-2_, so I used _/30_ as netmask with which you can address up to 2<sup>32-30</sup>-2=2 hosts

| Subnet | Devices (Interface)                   | Network address   | Netmask         | # of hosts              |
| ------ | ------------------------------------- | ----------------- | --------------- | ----------------------- |
| A      | router-1 (eth1.10)<br>host-1-a (eth1) | 172.22.1.0/24     | 255.255.255.0   | 2<sup>32-24</sup>-2=254 |
| B      | router-1 (eth1.20)<br>host-1-b (eth1) | 172.22.2.224/27   | 255.255.255.224 | 2<sup>32-27</sup>-2=30  |
| C      | router-2 (eth1)<br>host-2-c (eth1)    | 172.22.3.252/30   | 255.255.255.252 | 2<sup>32-30</sup>-2=2   |
| D      | router-1 (eth2)<br>router-2 (eth2)    | 172.31.255.252/30 | 255.255.255.252 | 2<sup>32-30</sup>-2=2   |

### VLANs

Due to only one connection between _router-1_ and _switch_, the use of virtual LANs is necessary. So I set up 2 VIDs for network A and B.

| VID | Subnet |
| --- | ------ |
| 10  | A      |
| 20  | B      |

### Interface-IP mapping

I chose lower IP addresses for hosts and higher for routers.

| Device   | Interface | IP                | Subnet |
| -------- | --------- | ----------------- | ------ |
| host-1-a | eth1      | 172.22.1.1/24     | A      |
| router-1 | eth1.10   | 172.22.1.254/24   | A      |
| host-1-b | eth1      | 172.22.2.225/27   | B      |
| router-1 | eth1.20   | 172.22.2.254/27   | B      |
| host-2-c | eth1      | 172.22.3.253/30   | C      |
| router-2 | eth1      | 172.22.3.254/30   | C      |
| router-1 | eth2      | 172.31.255.253/30 | D      |
| router-2 | eth2      | 172.31.255.254/30 | D      |

## Vagrant and devices configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create and configure 6 virtual machines, one for each network device.

```ruby
config.vm.define "router-1" do |router1|
  ...
end
config.vm.define "router-2" do |router2|
  ...
end
config.vm.define "switch" do |switch|
  ...
end
config.vm.define "host-1-a" do |host1a|
  ...
end
config.vm.define "host-1-b" do |host1b|
  ...
end
config.vm.define "host-2-c" do |host2c|
  ...
end
```

### router-1

#### router-1: Virtual machine configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create a trusty64 based virtual machine named _router-1_ and add 2 interfaces:

-   _eth1_ connected to _switch_
-   _eth2_ connected to _router-2_

```ruby
config.vm.define "router-1" do |router1|
  router1.vm.box = "minimal/trusty64"
  router1.vm.hostname = "router-1"
  router1.vm.network "private_network", virtualbox__intnet: "router1-switch", auto_config: false
  router1.vm.network "private_network", virtualbox__intnet: "router1-router2", auto_config: false
  router1.vm.provision "shell", path: "router-1.sh"
end
```

After VM installation, it will run _router-1.sh_ provisioning script.

#### router-1: Provisioning script

In [router-1.sh](/router-1.sh) with the following lines, I add the 2 VLAN links necessary to trunk the connection between _router-1_ and _switch_.

```bash
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
```

Then I assign IP addresses for each interface and set them up.

```bash
ip addr add 172.22.1.254/24 dev eth1.10
ip addr add 172.22.2.254/27 dev eth1.20
ip addr add 172.31.255.253/30 dev eth2
ip link set eth1 up
ip link set eth1.10 up
ip link set eth1.20 up
ip link set eth2 up
```

Finally I enable IP forwarding and FRRouting configuring OSPF protocol.

```bash
sysctl net.ipv4.ip_forward=1
sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'interface eth2' -c 'ip ospf area 0.0.0.0'
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'
```

### router-2

#### router-2: Virtual machine configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create a trusty64 based virtual machine named _router-2_ and add 2 interfaces:

-   _eth1_ connected to _host-2-c_
-   _eth2_ connected to _router-1_

```ruby
config.vm.define "router-2" do |router2|
  router2.vm.box = "minimal/trusty64"
  router2.vm.hostname = "router-2"
  router2.vm.network "private_network", virtualbox__intnet: "router2-host2c", auto_config: false
  router2.vm.network "private_network", virtualbox__intnet: "router1-router2", auto_config: false
  router2.vm.provision "shell", path: "router-2.sh"
end
```

After VM installation, it will run _router-2.sh_ provisioning script.

#### router-2: Provisioning script

In [router-2.sh](/router-2.sh) with the following lines, I assign IP addresses for each interface and set them up.

```bash
ip addr add 172.22.3.254/30 dev eth1
ip addr add 172.31.255.254/30 dev eth2
ip link set eth1 up
ip link set eth2 up
```

Finally I enable IP forwarding and FRRouting configuring OSPF protocol.

```bash
sysctl net.ipv4.ip_forward=1
sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
service frr restart
vtysh -c 'configure terminal' -c 'interface eth2' -c 'ip ospf area 0.0.0.0'
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'
```

### switch

#### switch: Virtual machine configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create a trusty64 based virtual machine named _switch_ and add 3 interfaces:

-   _eth1_ connected to _router-1_
-   _eth2_ connected to _host-1-a_
-   _eth3_ connected to _host-1-b_

```ruby
config.vm.define "switch" do |switch|
  switch.vm.box = "minimal/trusty64"
  switch.vm.hostname = "switch"
  switch.vm.network "private_network", virtualbox__intnet: "router1-switch", auto_config: false
  switch.vm.network "private_network", virtualbox__intnet: "switch-host1a", auto_config: false
  switch.vm.network "private_network", virtualbox__intnet: "switch-host1b", auto_config: false
  switch.vm.provision "shell", path: "switch.sh"
end
```

After VM installation, it will run _switch.sh_ provisioning script.

#### switch: Provisioning script

In [switch.sh](/switch.sh) with the following lines, I create a bridge named _switch_ and add the interfaces to it:

-   _eth1_ as a trunk port
-   _eth2_ as an access port for VLAN 10
-   _eth3_ as an access port for VLAN 20

```bash
ovs-vsctl add-br switch
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=10
ovs-vsctl add-port switch eth3 tag=20
```

Finally I set interfaces and ovs-system up.

```bash
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
ip link set dev ovs-system up
```

### host-1-a

#### host-1-a: Virtual machine configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create a trusty64 based virtual machine named _host-1-a_ and add interface _eth1_ connected to _switch_.

```ruby
config.vm.define "host-1-a" do |host1a|
  host1a.vm.box = "minimal/trusty64"
  host1a.vm.hostname = "host-1-a"
  host1a.vm.network "private_network", virtualbox__intnet: "switch-host1a", auto_config: false
  host1a.vm.provision "shell", path: "host-1-a.sh"
end
```

After VM installation, it will run _host-1-a.sh_ provisioning script.

#### host-1-a: Provisioning script

In [host-1-a.sh](/host-1-a.sh) with the following lines, I assign the IP address for interface _eth1_ and set it up. Finally I add a static route for class B private IP addresses to _router-1_.

```bash
ip addr add 172.22.1.1/24 dev eth1
ip link set eth1 up
ip route replace 172.16.0.0/12 via 172.22.1.254
```

### host-1-b

#### host-1-b: Virtual machine configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create a trusty64 based virtual machine named _host-1-b_ and add interface _eth1_ connected to _switch_.

```ruby
config.vm.define "host-1-b" do |host1b|
  host1b.vm.box = "minimal/trusty64"
  host1b.vm.hostname = "host-1-b"
  host1b.vm.network "private_network", virtualbox__intnet: "switch-host1b", auto_config: false
  host1b.vm.provision "shell", path: "host-1-b.sh"
end
```

After VM installation, it will run _host-1-b.sh_ provisioning script.

#### host-1-b: Provisioning script

In [host-1-b.sh](/host-1-b.sh) with the following lines, I assign the IP address for interface _eth1_ and set it up. Finally I add a static route for class B private IP addresses to _router-1_.

```bash
ip addr add 172.22.2.225/27 dev eth1
ip link set eth1 up
ip route replace 172.16.0.0/12 via 172.22.2.254
```

### host-2-c

#### host-2-c: Virtual machine configuration

In [Vagrantfile](/Vagrantfile) with the following lines, I create a trusty64 based virtual machine named _host-2-c_ and add interface _eth1_ connected to _router-2_.

```ruby
config.vm.define "host-2-c" do |host2c|
  host2c.vm.box = "minimal/trusty64"
  host2c.vm.hostname = "host-2-c"
  host2c.vm.network "private_network", virtualbox__intnet: "router2-host2c", auto_config: false
  host2c.vm.provision "shell", path: "host-2-c.sh"
end
```

After VM installation, it will run _host-2-c.sh_ provisioning script.

#### host-2-c: Provisioning script

In [host-2-c.sh](/host-2-c.sh) with the following lines, I assign the IP address for interface _eth1_ and set it up. Then I add a static route for class B private IP addresses to _router-2_.

```bash
ip addr add 172.22.3.253/30 dev eth1
ip link set eth1 up
ip route replace 172.16.0.0/12 via 172.22.3.254
```

Next I start an Apache container named _webserver_ on port 80 mounting `/var/www/` directory (`docker kill` and `docker rm` will clear any existing containers).

```bash
docker kill $(docker ps -q)
docker rm $(docker ps -aq)
docker run -dit --name webserver -p 80:80 -v /var/www/:/usr/local/apache2/htdocs/ httpd:2.4
```

Finally I write a simple HTML homepage in `/var/www/index.html`.

```bash
echo "<!DOCTYPE html>
<html>
<head>
<title>Home - hostc</title>
</head>
<body>
This is the hostc website homepage
</body>
</html>" > /var/www/index.html
```

## How-to

-   Install VirtualBox

-   Install Vagrant

-   Clone this repository

    ```bash
    ~$ git clone https://github.com/fabiodellagiustina/dncs-lab.git
    ```

-   Move into the repository and start creating the machines (on first launch, you don't need `--provision`, it will do it by default)

    ```bash
    ~$ cd dncs-lab/
    ~/dncs-lab$ vagrant up --provision
    ```

-   Now it's all set up

-   Use `vagrant ssh` to ssh into a running Vagrant machine, for example:

    ```bash
    ~/dncs-lab$ vagrant ssh host-1-a
    ```

-   To test reachability, you can now ping any machine from any other, for example to ping _host-1-b_ from _host-1-a_:

    ```bash
    ~/dncs-lab$ vagrant ssh host-1-a
    vagrant@host-1-a:~$ ping 172.22.2.225
    ```

    and vice versa:

    ```bash
    ~/dncs-lab$ vagrant ssh host-1-b
    vagrant@host-1-b:~$ ping 172.22.1.1
    ```

-   To browse the website hosted on _host-2-c_:

    ```bash
    curl 172.22.3.253
    ```

    The output will be:

    ```html
    <!DOCTYPE html>
    <html>
    <head>
    <title>Home - hostc</title>
    </head>
    <body>
    This is the hostc website homepage
    </body>
    </html>
    ```
