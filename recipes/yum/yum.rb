execute "update yum repo" do
  user "root"
  command "yum -y update"
end
