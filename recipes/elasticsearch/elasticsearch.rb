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

execute 'sudo rm -R /usr/local/share/elasticsearch' do
  not_if "test -e /usr/local/share/elaticsearch/bin/elasticsearch"
end

execute 'lib move' do
  command 'sudo mv elasticsearch-* /usr/local/share/elasticsearch'
end

template "/usr/local/share/elasticsearch/config/elasticsearch.yml" do 
  path "/usr/local/share/elasticsearch/config/elasticsearch.yml" # 任意指定。ここに記載するとブロック引数より優先される。
  source "../../templates/elasticsearch/config/elasticsearch_yml.erb" #必須指定。
  variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
end

