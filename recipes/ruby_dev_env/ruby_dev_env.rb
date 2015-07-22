include_recipe 'rtn_rbenv::system'

package 'git rbenv' do
  action :install
end
