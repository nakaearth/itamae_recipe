
if  /\A1.*/ =~ node[:elasticsearch][:version]
  include_recipe 'version/1_x.rb'
else
  include_recipe 'version/2_x.rb'
end
