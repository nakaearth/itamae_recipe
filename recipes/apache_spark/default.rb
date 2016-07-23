%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm spark.tar.gz' do
  only_if "test -e ~/elaticsearch.tar.gz"
end

execute 'spark file get' do
  command "wget http://ftp.jaist.ac.jp/pub/apache/spark/spark-#{node[:apache_spark][:version]}/spark-#{node[:apache_spark][:version]}.tgz"
end

execute 'file unzip' do
  command "tar -zxf spark-#{node[:apache_spark][:version]}.tar"
end

execute 'sudo rm -R /usr/local/share/spark' do
  only_if 'ls /usr/local/share/spark'
end

execute 'sudo mv spark-* /usr/local/share/spark' do
  not_if 'ls /usr/local/share/spark'
end

execute 'sudo chmod -R 777 /usr/local/share/spark' do
  only_if 'ls /usr/local/share/spark'
end

