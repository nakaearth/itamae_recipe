
if  /\A1.*/ =~ node[:elasticsearch][:version]
  include_recipe 'elasticsearch1.rb'
else
  include_recipe 'elasticsearch2.rb'
end
