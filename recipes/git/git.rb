%w( yum java-1.8.0-openjdk wget git ).each do |pkg|
  package pkg do
    action :install
  end
end

# アプリケーションの配置場所を作成
directory "#{node[:git][:app_path]}" do
  mode "755"
end

git "#{node[:git][:app_path]}" do
  repository "https://#{node[:git][:git_user]}:#{node[:git][:git_password]}@github.com/#{node[:git][:repository]}.git"
end
