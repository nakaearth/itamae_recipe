%w( yum wget ).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'rm kibana.tar.gz' do
  only_if "test -e #{node[:kibana][:install_path]}kibana.tar.gz"
end

execute 'kibana file get' do
  command "wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz -O kibana.tar.gz"
  cwd "#{node[:kibana][:install_path]}"
end

# TODO: 追加予定
