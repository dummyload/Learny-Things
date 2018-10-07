#!/bin/bash

# become root user
sudo -s

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
