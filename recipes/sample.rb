execute 'echo hello' do
  user 'vagrant'
  command "mkdir ~/test_dir"
end
