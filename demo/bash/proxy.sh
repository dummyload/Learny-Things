#!/bin/bash

# Script for setting up haproxy...


# become root...
sudo -s


# install and configure HAProxy
apt update -qq & apt install -y haproxy


cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak

# create the new haproxy file
cat << ENDOFCONF > /etc/haproxy/haproxy.cfg
frontend fe_http_front
    bind 192.168.200.254:80
    bind 192.168.100.200:80

    stats uri /haproxy?stats

    acl acl_stage_host hdr(host) -i staging
    use_backend be_http_staging if acl_stage_host

    acl acl_test_host hdr(host) -i testing
    use_backend be_http_testing if acl_test_host

    default_backend be_http_prod


backend be_http_prod
    mode http
    server prod-1 prod:80 check


backend be_http_staging
    mode http
    server staging staging:80 check


backend be_http_testing
    mode http
    server testing testing:80 check

ENDOFCONF

systemctl restart haproxy.service
systemctl enable haproxy.service
