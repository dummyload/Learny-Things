#!/bin/bash

# Script for setting up Firewall/Router

# become root user
sudo -s

echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg


# remove the Vagrant default gateway...
route del default gw 10.0.2.2
# # add the local...
route add default gw 192.168.100.254


# Vagrant does say not to mess with this file... But...
cat << ENDOFINTERFACES > /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# Source interfaces
source /etc/network/interfaces.d/*.cfg


# WAN interface
auto enp0s8
iface enp0s8 inet dhcp


# LAN interface
auto enp0s9
iface enp0s9 inet static
      address 192.168.200.254
      netmask 255.255.255.0

ENDOFINTERFACES


# enable IPv4 IP forwarding
sed -i s'/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf


iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

iptables-save > /etc/iptables.rules
cat << EOF > /etc/network/if-pre-up.d/iptables
#!/bin/sh
iptables-restore < /etc/iptables.rules
exit 0
EOF

cat << EOF > /etc/network/if-post-down.d/iptables
#!/bin/sh
iptables-save -c > /etc/iptables.rules
if [ -f /etc/iptables.rules ]; then
    iptables-restore < /etc/iptables.rules
fi
exit 0
EOF
