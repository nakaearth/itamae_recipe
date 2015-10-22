%w( yum wget git ).each do |pkg|
  package pkg do
    action :install
  end
end

# rubyをinstall
include_recipe '../recipes/ruby_dev_env/ruby_dev_env.rb'
# railsのinstall


# アプリケーションの配置場所を作成
directory "#{node[:git][:app_path]}" do
  action :create
end

git "#{node[:git][:app_path]}" do
  repository "https://#{node[:git][:git_user]}:#{node[:git][:git_password]}@github.com/#{node[:git][:repository]}.git"
end
