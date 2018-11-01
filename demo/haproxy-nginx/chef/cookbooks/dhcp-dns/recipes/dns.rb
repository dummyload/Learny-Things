apt_package 'bind9' do
  action :install
end

template '/etc/bind/named.conf.options' do
  content 'named.conf.options.erb'
  verify '/usr/sbin/named-checkconf %{path}'
end

template '/etc/bind/named.conf.local' do
  content 'named.conf.local.erb'
  verify '/usr/sbin/named-checkconf %{path}'
end

template '/etc/bind/db.test.cmdl.tech' do
  content 'db.test.cmdl.tech.erb'
  verify '/usr/sbin/named-checkzone test.cmdl.tech %{path}'
end

template '/etc/bind/db.200.168.192' do
  content 'db.200.168.192.erb'
  verify '/usr/sbin/named-checkzone 200.168.192.in-addr.arpa %{path}'
end

service 'bind9' do
  action [:enable, :restart]
end
