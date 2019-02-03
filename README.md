# DNCS-LAB assigment by Nicola Arnoldi

A.Y. 2018/19  
This repository contains the Vagrant files required to run the network.


## Table of contents

-   [Network map](#network-map)
-   [Network configuration](#network-configuration)
    -   [Subnets](#subnets)
    -   [VLANs](#vlans)
    -   [Interface-IP mapping](#interface-ip-mapping)
-   Reachability test
-   [How-to](#how-to)

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
| Subnet | Devices (Interface)                   | Network address   | Netmask         | # avaible IPs for the hosts              |
| ------ | ------------------------------------- | ----------------- | --------------- | ----------------------- |
| A      | router-1 (eth1.10)<br>host-1-a (eth1) | 172.27.1.0/24     | 255.255.255.0   |      [2<sup>32-24</sup>-2]=254 |
| B      | router-1 (eth1.20)<br>host-1-b (eth1) | 172.27.2.224/27   | 255.255.255.224 |      [2<sup>32-27</sup>-2]=30  |
| C      | router-2 (eth1)<br>host-2-c (eth1)    | 172.27.3.252/30   | 255.255.255.252 |      [2<sup>32-30</sup>-2]=2   |
| D      | router-1 (eth2)<br>router-2 (eth2)    | 172.31.255.252/30 | 255.255.255.252 |      [2<sup>32-30</sup>-2]=2   |

### VLANs

The newtork has only one connection between [_router-1_] and [_switch_], the use of virtual LANs is necessary. So I set up 2 VIDs for network A and B.

                 +------------+
                 |            |                
                 +  router-1  +
             eth0|            |eth2         
                 +-----+------+          +--------------+       
                       |eth1             | VID | Subnet |
                       |                 | --- | ------ |
                       |                 |  10 | A      |
                       |                 |  20 | B      |   
                       |                 +--------------+            
                       |                         
                       |eth1                   
            +----------+-----------+         
            |                      |           
            +        switch        |            
        eth0|                      |          
            +---+--------------+---+



### Interface-IP mapping

I chose lower IP addresses for hosts and higher for routers.

| Device   | Interface | IP                | Subnet | VLAN VID  |
|:--------:|:---------:|:-----------------:|:------:|:---------:|
| host-1-a | `eth1`    | 172.27.1.1/24     | A      | Untagged  |
| router-1 | `eth1.10` | 172.27.1.254/24   | A      |   10      |
| host-1-b | `eth1`    | 172.27.2.225/27   | B      | Untagged  |
| router-1 | `eth1.20` | 172.27.2.254/27   | B      |   20      |
| host-2-c | `eth1`    | 172.27.3.253/30   | C      | Untagged  |
| router-2 | `eth1`    | 172.27.3.254/30   | C      | Untagged  |
| router-1 | `eth2`    | 172.31.255.253/30 | D      |    --     |
| router-2 | `eth2`    | 172.31.255.254/30 | D      | Untagged  |

## Vagrant and devices configuration


In order to create and configure the network devices, in [Vagrantfile](/Vagrantfile) were introduce some lines as follow:

```ruby
config.vm.define "router-1" do |routera|
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


##Reachability

To test the reachability of the web server, you can ping any machine from any other, for example to ping _host-1-b_ from _host-1-a_:
' ping 172.27.2.225'


## How-to

-   Install VirtualBox

-   Install Vagrant

-   Clone this repository

    ```bash
    ~$ git clone
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
    vagrant@host-1-a:~$ ping 172.27.2.225
    ```

    and vice versa:

    ```bash
    ~/dncs-lab$ vagrant ssh host-1-b
    vagrant@host-1-b:~$ ping 172.27.1.1
    ```

-   To browse the website hosted on _host-2-c_:

    ```bash
    curl 172.27.3.253
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
