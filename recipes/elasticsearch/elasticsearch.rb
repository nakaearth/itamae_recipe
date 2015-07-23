%w( yum java-1.8.0-openjdk ).each do |pkg|
  package pkg do
    action :install
  end
end

file "/etc/yum.repos.d/elasticsearch.reop" do
  content "[elasticsearch-1.0]\n
           name=Elasticsearch repository for 1.0.x packages\n
           baseurl=http://packages.elasticsearch.org/elasticsearch/1.0/centos\n
           gpgcheck=1\n
           $gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch\n
           enabled=1\n"
end

package 'elasticsearch' do
  action :install
end
