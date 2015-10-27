# rubyをinstall
include_recipe '../../recipes/ruby_dev_env/ruby_dev_env.rb'

execute 'gem install fluentd --no-ri --no-rdoc'

