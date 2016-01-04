%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm elasticsearch.tar.gz' do
  only_if "test -e ~/elaticsearch.tar.gz"
end

execute 'elasticsearch file get' do
  command "wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/#{node[:elasticsearch][:version]}/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz -O elasticsearch.tar.gz"
end

execute 'rm kibana.tar.gz' do
  only_if "test -e ~/kibana.tar.gz"
end

# kibana
execute 'kibana.tar.gz' do
  command "wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-darwin-x64.tar.gz -O kibana.tar.gz"
end

execute 'file unzip' do
  command 'tar -zxf elasticsearch.tar.gz'
end

# kibana
execute 'kinaba unzip' do
  command 'tar -zxvf kibana.tar.gz'
end

execute 'sudo rm -R /usr/local/share/elasticsearch' do
  only_if 'ls /usr/local/share/elasticsearch'
end

execute 'sudo mv elasticsearch-* /usr/local/share/elasticsearch' do
  not_if 'ls /usr/local/share/elasticsearch'
end

# kibana
execute 'sudo rm -R /usr/local/share/kibana' do
  only_if 'ls /usr/local/share/kibana'
end

execute 'sudo mv kibana-* /usr/local/share/kibana' do
  not_if 'ls /usr/local/share/kibana'
end

execute 'sudo chmod -R 775 /usr/local/share/elasticsearch' do
  only_if 'ls /usr/local/share/elasticsearch'
end

# kibana
execute 'sudo chmod -R 775 /usr/local/share/kibana' do
  only_if 'ls /usr/local/share/kibana'
end

execute 'mkdir /usr/local/share/elasticsearch/plugins' do
  not_if 'ls /usr/local/share/elasticsearch/plugins'
end

# プラグイン
## HEAD
execute 'bin/plugin remove mobz/elasticsearch-head' do
  only_if 'cd /usr/local/share/elasticsearch/plugins/head'
  cwd '/usr/local/share/elasticsearch'
end

execute 'bin/plugin install mobz/elasticsearch-head' do
  cwd '/usr/local/share/elasticsearch'
end

## kuromoji
execute "bin/plugin remove analysis-kuromoji" do
  only_if 'cd /usr/local/share/elasticsearch/plugins/analysis-kuromoji'
  cwd '/usr/local/share/elasticsearch'
end

execute "bin/plugin install analysis-kuromoji" do
  cwd '/usr/local/share/elasticsearch'
end

# mavel
 execute "bin/plugin remove license" do
  only_if 'cd /usr/local/share/elasticsearch/plugins/license'
  cwd '/usr/local/share/elasticsearch'
end

execute "bin/plugin install license" do
  cwd '/usr/local/share/elasticsearch'
end

execute "bin/plugin remove marvel-agent" do
  only_if 'cd /usr/local/share/elasticsearch/plugins/marvel-agent'
  cwd '/usr/local/share/elasticsearch'
end

execute "bin/plugin install marvel-agent" do
  cwd '/usr/local/share/elasticsearch'
end

# marvel plugin
execute './bin/kibana plugin -i elasticsearch/marvel-ui/latest' do
  cwd '/usr/local/share/kibana'
end

# elasticsearch.yml
template "/usr/local/share/elasticsearch/config/elasticsearch.yml" do
  path "/usr/local/share/elasticsearch/config/elasticsearch.yml" # 任意指定。ここに記載するとブロック引数より優先される。
  source "../../../templates/elasticsearch/config/elasticsearch2_yml.erb" #必須指定。
  variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
end

#execute "bin/elasticsearch -d" do
#  cwd '/usr/local/share/elasticsearch'
#end
