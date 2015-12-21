%w( yum java-1.8.0-openjdk wget git ).each do |pkg|
  package pkg do
    action :install
  end
end

# rubyをinstall
include_recipe "rbenv::user"

# mysqlをinstall
include_recipe '../recipes/mysql/mysql.rb'

# elasticsearchのinstall
include_recipe '../recipes/elasticsearch/elasticsearch.rb'

include_recipe '../recipes/redis/redis.rb'

# アプリケーションの配置場所を作成
include_recipe '../recipes/git/git.rb'
