# DNCS-LAB | Lecture 25/10/2018

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


VAGRANT
MANAGEMENT

 +------+
 |      |
 |      +---------------------------------------------+
 |      |                                         eth0|
 |      |           +--------+                    +--------+
 |      |           |        |                    |        |
 |      |       eth0|        |                    |        |
 |      +-----------+ROUTER A+-------------------->ROUTER C|
 |      |           |        |eth2            eth2|        |
 |      |           |        |                    |        |
 |      |           +--------+                    +--------+
 |      |               |eth1                           |eth1
 |      |               |                               |
 |      |               |eth1                           |eth1
 |      |       +-------v--------+                  +---v--+
 |      |       |                |                  |      |
 |      |   eth0|    SWITCH      |                  |      |
 |      +-------+                |                  |HOST C|
 |      |       |                |                  |      |
 |      |       +----------------+                  +------+
 |      |           |eth2     |eth3                    |eth0
 |      |           |eth1     |eth1                    |
 |      |       +---v--+  +---v--+                     |
 |      |       |      |  |      |                     |
 |      |   eth0|      |  |      |                     |
 |      +-------+HOST A|  |HOST B|                     |
 |      |       |      |  |      |                     |
 |      |       +------+  +-+----+                     |
 |      |                   | eth0                     |
 |      +-------------------+                          |
 |      +----------------------------------------------+
 +------+

```

# Requirements
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/davidegagliardi/dncs-lab251018`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab-251018
[~/dncs-lab-251018] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab-251018]$ vagrant status                                                                                                                                                                
Current machine states:

router-a                  running (virtualbox)
router-c                  running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
host-c                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router-a`
`vagrant ssh router-c`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

- Remember to provision host-b using the command `vagrant provision host-b`

- Please control VM status with `vagrant status`, if a VM is not working please run `vagrant up <VM>`

# Configuration Step-By-Step

- ROUTER1
```
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
```
- ROUTER2
```
ip addr add 192.168.30.254/24 dev eth1
ip addr add 192.168.255.254/30 dev eth2
ip link set eth1 up
ip link set eth2 up
sysctl net.ipv4.ip_forward=1
```
- SWITCH
```
ovs-vsctl add-br switch
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=10
ovs-vsctl add-port switch eth3 tag=20
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up
ip link set dev ovs-system up
```
- HOST-A
```
ip addr add 192.168.10.1/24 dev eth1
ip link set eth1 up
```
- HOST-B
```
ip addr add 192.168.20.1/24 dev eth1
ip link set eth1 up
```
- HOST-C
```
ip addr add 192.168.30.1/24 dev eth1
ip link set eth1 up
```
