#!/bin/bash

# become root user
sudo -s

# remove the Vagrant default gateway...
route del default gw 10.0.2.2
# # add the local...
route add default gw 192.168.100.254


# update and install ngnix
apt update -qq && apt install -yq nginx

cat << ENDOFHTML > /var/www/html/index.html
<hmtl>
    <head>
        <title>$(hostname)</title>
    </head>
    <body>
        <h1>$(hostname)</h1>
        <p>Welcome to the $(hostname) web server</p>
    </body>
</html>
ENDOFHTML
