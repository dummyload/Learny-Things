apt_package 'haproxy' do
  action :install
end

template '/etc/haproxy/haproxy.cfg.new' do
  source 'haproxy.cfg.erb'
  verify '/usr/sbin/haproxy -c -f %{path}'
end

remote_file '/etc/haproxy/haproxy.cfg' do
  path '/etc/haproxy/haproxy.cfg'
  source 'file:///etc/haproxy/haproxy.cfg.new'
end

service 'haproxy' do
  action [:enable, :reload]
end

template '/etc/sysctl.conf' do
  source 'sysctl.conf.erb'
end

execute 'reload sysctl.conf' do
  command 'sysctl -p /etc/sysctl.conf'
end

execute "set up routing - 1" do
  command "iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE"
end

execute "set up routing - 2" do
  command "iptables -A FORWARD -i eth2 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT"
end

execute "set up routing - 3" do
  command "iptables -A FORWARD -i eth2 -o eth1 -j ACCEPT"
end

execute "set up routing - 4" do
  command "iptables-save > /etc/iptables.rules"
end

file '/etc/network/if-pre-up.d/iptables' do
  content '#!/bin/sh
  iptables-restore < /etc/iptables.rules
  exit 0'
end

file '/etc/network/if-post-down.d/iptables' do
  content '#!/bin/sh
  iptables-save -c > /etc/iptables.rules
  if [ -f /etc/iptables.rules ]; then
      iptables-restore < /etc/iptables.rules
  fi
  exit 0'
end
