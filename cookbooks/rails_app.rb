%w( yum wget git ).each do |pkg|
  package pkg do
    action :install
  end
end

directory "#{node[:git][:app_path]}" do
  action :create
end

git "#{node[:git][:app_path]}" do
  repository "#{node[:git][:repository]}"
end
