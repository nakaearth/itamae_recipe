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

execute 'rm -R kibana' do
  only_if 'ls kibana'
  cwd "#{node[:kibana][:install_path]}"
end

# TODO: 追加予定
execute 'file unzip' do
  command 'tar -zxf kibana.tar.gz'
  cwd "#{node[:kibana][:install_path]}"
end

execute 'mv kibana-* elasticsearch' do
  not_if "ls #{node[:kibana][:install_path]}kibana"
  cwd "#{node[:kibana][:install_path]}"
end

execute 'chmod -R 777 kibana' do
  only_if "ls #{node[:kibana][:install_path]}kibana"
  cwd "#{node[:kibana][:install_path]}"
end


