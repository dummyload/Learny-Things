#!/bin/bash

# become root user
sudo -s

# install DHCP server
apt install -y isc-dhcp-server

# set the DHCP interface
echo 'INTERFACES="enp0s9"' > /etc/default/isc-dhcp-server

# set up the DHCP config file
cat << ENDOFDHCP > /etc/dhcp/dhcpd.conf
# option definitions common to all supported networks...
option domain-name "test.cmdl.tech";
option domain-name-servers 192.168.100.254;

default-lease-time 3600;
max-lease-time 7200;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

subnet 192.168.200.0 netmask 255.255.255.0 {
        option routers                192.168.200.254;
        option subnet-mask            255.255.255.0;
        option domain-search          "test.cmdl.tech";
        option domain-name-servers    192.168.200.254;
        range 192.168.200.50 192.168.200.59;
}


host testing {
    hardware ethernet 5C:A1:AB:1E:10:00;
    fixed-address 192.168.200.100;
}

host staging {
    hardware ethernet 5C:A1:AB:1E:10:01;
    fixed-address 192.168.200.101;
}

host prod {
    hardware ethernet 5C:A1:AB:1E:10:02;
    fixed-address 192.168.200.102;
}

ENDOFDHCP

# start the server...
systemctl start isc-dhcp-server.service
systemctl enable isc-dhcp-server.service
