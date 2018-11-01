name "firewall"
description "A role for configuring firewalls."

run_list ["recipe[dhcp-dns]", "recipe[haproxy]"]
