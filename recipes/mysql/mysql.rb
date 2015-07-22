execute 'yum -y remove mysql*'

package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm'

%w( mysql-community-server mysql-community-devel ).each do |pkg|
  package pkg
end

service 'mysqld' do
  action :start
end
