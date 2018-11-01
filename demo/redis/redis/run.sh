#!/bin/bash

# VARS
IP_ADDR=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')


sed -i "s/%IP_ADDR%/${IP_ADDR}/" /redis/redis.conf


# run redis
/usr/bin/redis-server /redis/redis.conf
