%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm elasticsearch.tar.gz' do
  only_if "test -e ~/elaticsearch.tar.gz"
end


if  /\A1.*/ =~ node[:elasticsearch][:version]
  execute 'elasticsearch file get' do
    command "wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz -O elasticsearch.tar.gz"
  end
else
  execute 'elasticsearch file get' do
    command "wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/#{node[:elasticsearch][:version]}/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz -O elasticsearch.tar.gz"
  end
end

execute 'file unzip' do
  command 'tar -zxf elasticsearch.tar.gz'
end

execute 'sudo rm -R /usr/local/share/elasticsearch' do
  only_if 'ls /usr/local/share/elasticsearch'
end

execute 'sudo mv elasticsearch-* /usr/local/share/elasticsearch' do
  not_if 'ls /usr/local/share/elasticsearch'
end

execute 'sudo chmod -R 755 /usr/local/share/elasticsearch' do
  only_if 'ls /usr/local/share/elasticsearch'
end

# elasticsearch.ymlをコピー
if  /\A1.*/ =~ node[:elasticsearch][:version]
  template "/usr/local/share/elasticsearch/config/elasticsearch.yml" do 
    path "/usr/local/share/elasticsearch/config/elasticsearch.yml" # 任意指定。ここに記載するとブロック引数より優先される。
    source "../../templates/elasticsearch/config/elasticsearch_yml.erb" #必須指定。
    variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
  end

  # プラグイン
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
else
  execute "sudo chmod -R 777 /usr/local/share/elasticsearch" do
    only_if 'cd /usr/local/share/elasticsearch/'
    cwd '/usr/local/share/elasticsearch'
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

  template "/usr/local/share/elasticsearch/config/elasticsearch.yml" do 
    path "/usr/local/share/elasticsearch/config/elasticsearch.yml" # 任意指定。ここに記載するとブロック引数より優先される。
    source "../../templates/elasticsearch/config/elasticsearch2_yml.erb" #必須指定。
    variables({cluster_name: 'nakamura-elasticsearch', index_shards_num: "5", index_replicas_num: "1"}) # 任意指定。
  end

  execute "bin/elasticsearch -d" do
    cwd '/usr/local/share/elasticsearch'
  end
end
