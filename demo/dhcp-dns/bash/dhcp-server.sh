#!/bin/bash

# VARS
DHCP_CONF="/etc/dhcp/dhcpd.conf"


# ensure running as sudo
if [[ $(id) != 0 ]];
then
    sudo -s
fi

# install DHCP server
apt update && apt install -y isc-dhcp-server


echo 'INTERFACES="eth1"' > /etc/default/isc-dhcp-server

# set up the DHCP config file
cat << ENDOFDHCP > ${DHCP_CONF}
# option definitions common to all supported networks...
option domain-name "test.cmdl.tech";
# option domain-name-servers 192.168.100.254;

default-lease-time 3600;
max-lease-time 7200;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

failover peer "dhcp-failover" {
  %ROLE%;
  address %THIS_IP%;
  port %THIS_PORT%;
  peer address %OTHER_IP%;
  peer port %OTHER_PORT%;
  max-response-delay 60;
  max-unacked-updates 10;
  load balance max seconds 3;
  mclt 3600;
  split 128;
}

subnet 192.168.200.0 netmask 255.255.255.0 {

    option routers                192.168.200.254;
    option subnet-mask            255.255.255.0;
    option domain-search          "test.cmdl.tech";
    option domain-name-servers    192.168.200.254;

    pool {
        failover peer "dhcp-failover";
        range 192.168.200.50 192.168.200.59;
    }
}

omapi-port 7911;
omapi-key my-omapi-key;

key my-omapi-key {
    algorithm hmac-md5;
    secret FJXuPpXUqrQRLyyyv9YfEg9OrxRVnQ==;
}

ENDOFDHCP

if [ $(hostname) == "dhcpd-1" ];
then
    sed -i "s/%ROLE%/primary/" "${DHCP_CONF}"
    sed -i "s/%THIS_IP%/192.168.200.253/" "${DHCP_CONF}"
    sed -i "s/%THIS_PORT%/519/" "${DHCP_CONF}"
    sed -i "s/%OTHER_IP%/192.168.200.252/" "${DHCP_CONF}"
    sed -i "s/%OTHER_PORT%/520/" "${DHCP_CONF}"
else
    sed -i "s/%ROLE%/secondary/" "${DHCP_CONF}"
    sed -i "s/%THIS_IP%/192.168.200.252/" "${DHCP_CONF}"
    sed -i "s/%THIS_PORT%/520/" "${DHCP_CONF}"
    sed -i "s/%OTHER_IP%/192.168.200.253/" "${DHCP_CONF}"
    sed -i "s/%OTHER_PORT%/519/" "${DHCP_CONF}"
fi


# start the server...
systemctl start isc-dhcp-server.service
systemctl enable isc-dhcp-server.service
