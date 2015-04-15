package 'nginx' do
  action :install
end

directory "/etc/nginx" do
  action :create # デフォルトのため記載不要だが書いたほうが可読性が高い
  mode "755" # 任意指定
  owner "vagrant" # 任意指定
  group "vagrant" # 任意指定
end

directory "/var/log/nginx" do
  action :create # デフォルトのため記載不要だが書いたほうが可読性が高い
  mode "755" # 任意指定
  owner "vagrant" # 任意指定
  group "vagrant" # 任意指定
end

template "/etc/nginx/nginx.conf" do 
  source "../../template/nginx/nginx_conf.rb"
  # path ""
  variables({"error_log_path" => "#{node["error_log_path"]}"})
end

service 'nginx' do
  action [:enable, :start]
end
