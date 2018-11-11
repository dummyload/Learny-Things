#!/bin/bash

LEASES_FILE=/dhcpd/dhcpd.leases

if [[ ! -e $LEASES_FILE ]]; then
    touch $LEASES_FILE
fi

$(which dhcpd) -f -cf /dhcpd/dhcpd.conf
