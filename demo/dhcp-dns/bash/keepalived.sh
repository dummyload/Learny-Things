#!/bin/bash

# VARS
KEEP_CONF=/etc/keepalived/keepalived.conf


# ensure running as sudo
if [[ $(id) != 0 ]];
then
    sudo -s
fi


apt update && apt install -y keepalived

cat << ENDOFCONF > $KEEP_CONF
vrrp_instance VI_1 {
    interface eth1
    state %STATE%
    priority 200

    virtual_router_id 33
    unicast_src_ip %THIS_IP%
    unicast_peer {
        %OTHER_IP%
    }

    authentication {
        auth_type PASS
        auth_pass password
    }
    virtual_ipaddress {
        192.168.200.254
    }
}
ENDOFCONF

if [ $(hostname) == "dhcpd-1" ];
then
    sed -i "s/%STATE%/master/" "$KEEP_CONF"
    sed -i "s/%THIS_IP%/192.168.200.253/" "$KEEP_CONF"
    sed -i "s/%OTHER_IP%/192.168.200.252/" "$KEEP_CONF"
else
    sed -i "s/%STATE%/backup/" "$KEEP_CONF"
    sed -i "s/%THIS_IP%/192.168.200.252/" "$KEEP_CONF"
    sed -i "s/%OTHER_IP%/192.168.200.253/" "$KEEP_CONF"
fi

systemctl start keepalived.service
systemctl enable keepalived.service
