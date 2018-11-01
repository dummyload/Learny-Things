name "web-server"
description "A role for configuring web servers."

# run_list ["recipe[base]", "recipe[web-servers]"]
run_list [ "recipe[web-servers]"]
