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

execute 'rm -R elasticsearch' do
  only_if 'ls elasticsearch'
end

execute 'mv elasticsearch-* elasticsearch' do
  not_if 'ls elasticsearch'
end

# kibana
execute 'rm -R kibana' do
  only_if 'ls kibana'
end

execute 'mv kibana-* kibana' do
  not_if 'ls kibana'
end

execute 'chmod -R 777 elasticsearch' do
  only_if 'ls elasticsearch'
end

# kibana
execute 'chmod -R 777 kibana' do
  only_if 'ls kibana'
end

execute 'mkdir elasticsearch/plugins' do
  not_if 'ls elasticsearch/plugins'
end

# プラグイン
## HEAD
execute 'bin/plugin remove mobz/elasticsearch-head' do
  only_if 'cd elasticsearch/plugins/head'
  cwd 'elasticsearch'
end

execute 'bin/plugin install mobz/elasticsearch-head' do
  cwd 'elasticsearch'
end

## kuromoji
execute "bin/plugin remove analysis-kuromoji" do
  only_if 'cd elasticsearch/plugins/analysis-kuromoji'
  cwd 'elasticsearch'
end

execute "bin/plugin install analysis-kuromoji" do
  cwd 'elasticsearch'
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
  source "../../../templates/elasticsearch/config/elasticsearch2_yml.erb" #必須指定。
  variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
end

execute "bin/elasticsearch -d &" do
  cwd 'elasticsearch'
end
