execute 'echo hello' do
  user 'vagrant'
  command "echo 'hoge'"
end

execute "update yum repo" do
  user "root"
  command "yum -y update"
end

directory "/usr/local/test" do
  action :create
  mode '777'
  owner 'vagrant'
  group 'vagrant'
end


file "test" do
  content 'ほげ'
  mode '777'
  owner 'vagrant'
  group 'vagrant'
end


