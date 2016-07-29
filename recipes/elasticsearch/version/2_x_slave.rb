%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm elasticsearch.tar.gz' do
  only_if "test -e #{node[:elasticsearch][:install_path]}elaticsearch.tar.gz"
  cwd "#{node[:elasticsearch][:install_path]}"
end

execute 'elasticsearch file get' do
  command "wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/#{node[:elasticsearch][:version]}/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz -O elasticsearch.tar.gz"
  cwd "#{node[:elasticsearch][:install_path]}"
end

execute 'rm -R elasticsearch' do
  only_if 'ls elasticsearch'
  cwd "#{node[:elasticsearch][:install_path]}"
end

execute 'file unzip' do
  command 'tar -zxf elasticsearch.tar.gz'
  cwd "#{node[:elasticsearch][:install_path]}"
end

execute 'mv elasticsearch-* elasticsearch' do
  not_if "ls #{node[:elasticsearch][:install_path]}elasticsearch"
  cwd "#{node[:elasticsearch][:install_path]}"
end

execute 'chmod -R 777 elasticsearch' do
  only_if "ls #{node[:elasticsearch][:install_path]}elasticsearch"
  cwd "#{node[:elasticsearch][:install_path]}"
end

execute 'mkdir elasticsearch/plugins' do
  not_if 'ls elasticsearch/plugins'
  cwd "#{node[:elasticsearch][:install_path]}"
end

# プラグイン
## HEAD
execute 'bin/plugin remove mobz/elasticsearch-head' do
  only_if 'cd elasticsearch/plugins/head'
  cwd "#{node[:elasticsearch][:install_path]}elasticsearch"
end

execute 'bin/plugin install mobz/elasticsearch-head' do
  cwd "#{node[:elasticsearch][:install_path]}elasticsearch"
end

## kuromoji
execute "bin/plugin remove analysis-kuromoji" do
  only_if 'cd elasticsearch/plugins/analysis-kuromoji'
  cwd "#{node[:elasticsearch][:install_path]}elasticsearch"
end

execute "bin/plugin install analysis-kuromoji" do
  cwd "#{node[:elasticsearch][:install_path]}elasticsearch"
end

# mavel
# execute "bin/plugin remove license" do
#  only_if 'cd elasticsearch/plugins/license'
#  cwd 'elasticsearch'
#end

#execute "bin/plugin install license" do
#  cwd 'elasticsearch'
#end
#
#execute "bin/plugin remove marvel-agent" do
#  only_if 'cd elasticsearch/plugins/marvel-agent'
#  cwd 'elasticsearch'
#end
#
#execute "bin/plugin install marvel-agent" do
#  cwd 'elasticsearch'
##end

# marvel plugin
#execute './bin/kibana plugin -i elasticsearch/marvel-ui/latest' do
#  cwd 'kibana'
#end

# elasticsearch.yml
template "elasticsearch/config/elasticsearch.yml" do
  path "elasticsearch/config/elasticsearch.yml" # 任意指定。ここに記載するとブロック引数より優先される。
  source "../../../templates/elasticsearch/config/elasticsearch2_slave_yml.erb" #必須指定。
  variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
end

execute "bin/elasticsearch -d &" do
  cwd "#{node[:elasticsearch][:install_path]}elasticsearch"
end

execute "sudo systemctl stop firewalld"
