%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm elasticsearch.tar.gz' do
  only_if "test -e ~/elaticsearch.tar.gz"
end

execute 'elasticsearch file get' do
  command 'wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.0.tar.gz -O elasticsearch.tar.gz'
end

execute 'file unzip' do
  command 'tar -zxf elasticsearch.tar.gz'
end

execute 'sudo mv elasticsearch-* /usr/local/share/elasticsearch' do
  only_if 'sudo rm -R /usr/local/share/elasticsearch'
end

execute 'chmmod' do
  command 'sudo chmod -R 755 /usr/local/share/elasticsearch'
end

template "/usr/local/share/elasticsearch/config/elasticsearch.yml" do 
  path "/usr/local/share/elasticsearch/config/elasticsearch.yml" # 任意指定。ここに記載するとブロック引数より優先される。
  source "../../templates/elasticsearch/config/elasticsearch_yml.erb" #必須指定。
  variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
end

execute 'bin/plugin --remove mobz/elasticsearch-head' do
  only_if 'cd /usr/local/share/elasticsearch/plugins/head'
  cwd '/usr/local/share/elasticsearch'
end

execute 'bin/plugin -install mobz/elasticsearch-head' do
  cwd '/usr/local/share/elasticsearch'
end

execute 'bin/plugin --remove elasticsearch/marvel/latest' do
  only_if 'cd /usr/local/share/elasticsearch/plugins/mavel'
  cwd '/usr/local/share/elasticsearch'
end

execute 'bin/plugin -install elasticsearch/marvel/latest' do
  cwd '/usr/local/share/elasticsearch'
end

execute "bin/plugin --remove elasticsearch/elasticsearch-analysis-kuromoji/#{node['elasticsearch']['plugin']['kuromoji']['version']}" do
  only_if 'cd /usr/local/share/elasticsearch/plugins/analysis-kuromoji'
  cwd '/usr/local/share/elasticsearch'
end

execute "bin/plugin -install elasticsearch/elasticsearch-analysis-kuromoji/#{node['elasticsearch']['plugin']['kuromoji']['version']}" do
  cwd '/usr/local/share/elasticsearch'
end
