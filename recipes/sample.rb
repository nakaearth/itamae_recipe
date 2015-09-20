execute 'echo hello' do
  user 'vagrant'
  command "mkdir ~/test_dir"
end

execute "update yum repo" do
  user "root"
  command "yum -y update"
end
