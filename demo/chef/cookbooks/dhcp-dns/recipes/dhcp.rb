apt_package 'isc-dhcp-server' do
  action :install
end

file '/etc/default/isc-dhcp-server' do
  content 'INTERFACES="enp0s9"'
end

template '/etc/dhcp/dhcpd.conf.new' do
  source 'dhcp.erb'
  verify 'dhcpd -t -cf %{path}'
end

remote_file '/etc/dhcp/dhcpd.conf' do
  path '/etc/dhcp/dhcpd.conf'
  source 'file:///etc/dhcp/dhcpd.conf.new'
end

service 'isc-dhcp-server' do
  action [:enable, :restart]
end
