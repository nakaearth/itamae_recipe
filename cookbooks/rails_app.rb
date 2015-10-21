%w( yum wget git ).each do |pkg|
  package pkg do
    action :install
  end
end

execute "mkdir #{node[:git][:app_path]}" do
  not_if "ls #{node[:git][:app_path] }"
end

execute "git clone  #{node[:git][:repository]} #{node[:git][:app_path]}" do
  only_if "git -h"
end
