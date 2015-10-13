%w( yum wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute "rm redis-#{node['redis']['version']}.tar.gz" do
  only_if "test -e redis-#{node['redis']['version']}.tar.gz"
end

execute 'redis file get' do
  command "wget http://download.redis.io/releases/redis-#{node['redis']['version']}.tar.gz"
end

execute 'unzip' do
  command "tar -zxf redis-#{node['redis']['version']}.tar.gz"
end

execute 'make' do
  cwd "redis-#{node['redis']['version']}"
end

execute 'sudo make install' do
  cwd "redis-#{node['redis']['version']}"
end
