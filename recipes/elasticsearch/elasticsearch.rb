%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'elasticsearch file get' do
  command 'wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.0.tar.gz -O elasticsearch.tar.gz'
end

execute 'file unzip' do
  command 'tar -xf elsticsearch.tar.gz'
end

execute 'remove tar' do
  command 'rm elasticsearch.tar.gz'
end

execute 'lib move' do
  command 'mv elasticsearch-* elasticsearch'
end

execute 'move directory' do
  command 'sudo mv elasticsearch /usr/local/share'
end

#execute 'remove yum repo file' do
##  command 'sudo rm /etc/yum.repos.d/elasticsearch.repo'
#end

#execute 'add repo' do
#  user 'root'
#  command 'rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch'
#end

#file "/etc/yum.repos.d/elasticsearch.reop" do
#  user 'root'
#  content "[elasticsearch-1.7]
#name=Elasticsearch repository for 1.7 packages
#baseurl=http://packages.elasticsearch.org/elasticsearch/1.7/centos
#gpgcheck=1
#$gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
#enabled=1"
#end

#package 'elasticsearch' do
#  user 'root'
#  action :install
#end
