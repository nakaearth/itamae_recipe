%w( yum wget git ).each do |pkg|
  package pkg do
    action :install
  end
end

directory "#{node[:git][:app_path]}" do
  action :create
end

git "#{node[:git][:app_path]}" do
  repository "https://#{node[:git][:git_user]}:#{node[:git][:git_password]}@github.com/#{node[:git][:repository]}.git"
end
