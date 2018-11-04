#!/bin/bash

# VARS
IP_ADDR=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

# setup redis.conf
sed -i "s/%IP_ADDR%/${IP_ADDR}/" /redis/redis.conf


# setup sentinel.conf
sed -i "s/%IP_ADDR%/${IP_ADDR}/" /redis/sentinel.conf

# Ideally, two seperate containers would be used for both the Redis
# server and sentinel, but for the ease of simplicity I'll run them


# run redis
redis-server /redis/redis.conf

# run sentinel
redis-server /redis/sentinel.conf --sentinel
