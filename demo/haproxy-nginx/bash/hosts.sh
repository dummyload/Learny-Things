#!/bin/bash

# append hostsname to hosts file
cat << ENDOFHOSTS >> /etc/hosts

192.168.200.254     proxy-master-01
192.168.200.100     testing
192.168.200.101     staging
192.168.200.102     prod
ENDOFHOSTS
