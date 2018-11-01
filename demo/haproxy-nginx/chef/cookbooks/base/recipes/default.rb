execute "delete default vagrant route" do
  command "route del default gw 10.0.2.2"
  ignore_failure true
end

execute "add new default route" do
  command "route add default gw 192.168.200.254"
  ignore_failure true
end
