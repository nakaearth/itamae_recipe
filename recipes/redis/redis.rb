%w( yum wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm redis-3.0.4.tar.gz' do
  only_if "test -e redis-3.0.4.tar.gz"
end

execute 'redis file get' do
  command 'wget http://download.redis.io/releases/redis-3.0.4.tar.gz'
end

execute 'unzip' do
  command 'tar -zxf redis-3.0.4.tar.gz'
end

execute 'make' do
  cwd 'redis-3.0.4'
end

execute 'sudo make install' do
  cwd 'redis-3.0.4'
end
