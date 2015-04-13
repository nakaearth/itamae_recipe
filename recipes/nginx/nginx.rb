package 'nginx' do
  action :install
end

template "/etc/nginx/nginx.conf" do 
 source "../../template/nginx/nginx_conf.rb"
 # path ""
 # variables({"param1" => "value1"}) # 任意指定。
end

service 'nginx' do
  action [:enable, :start]
end
