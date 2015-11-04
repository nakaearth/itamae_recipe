# rubyをinstall
include_recipe '../../recipes/ruby_dev_env/ruby_dev_env.rb'

# fluentd のプラグイン
fluent_plugins = %w( fluent-plugin-slack fluent-plugin-elasticsearch )
fluent_plugins.each do |plugin|
  execute "fluent-gem install '#{plugin}'"
end

