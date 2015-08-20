%w( yum java-1.8.0-openjdk wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'elasticsearch file get' do
  command 'wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.0.tar.gz -O elasticsearch.tar.gz'
end

execute 'file unzip' do
  command 'tar -zxf elasticsearch.tar.gz'
end

execute 'remove tar' do
  command 'rm elasticsearch.tar.gz'
end

execute 'sudo rm -R /usr/local/share/elasticsearch' do
   if "test -d /usr/local/share/elaticsearch"
end

execute 'lib move' do
  command 'sudo mv elasticsearch-* elasticsearch'
end

