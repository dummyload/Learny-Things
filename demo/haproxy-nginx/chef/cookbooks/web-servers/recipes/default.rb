apt_package 'nginx' do
  action :install
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
