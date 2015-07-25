flyway "install_flyway_#{node[:oracle][:ora_base]}" do
  install_dir node[:oracle][:ora_base]
  version node[:base_oracle_db][:flyway]['version']
  owner node[:oracle][:user][:edb]
  group node[:oracle][:cliuser][:sup_grps].keys[0]
  action :install
end

flyway "migrate_flyway_#{node[:base_oracle_db][:flyway][:locations]}" do
  location node[:base_oracle_db][:schema][:user][:locations]
  url "jdbc:oracle:thin:@//#{node[:base_oracle_db][:hostname]}:1521/DB1"
  user node[:base_oracle_db][:schema][:user][:name]
  password node[:base_oracle_db][:schema][:user][:password]
  install_dir "#{node[:oracle][:ora_base]}"
  owner 'oracle'
  action :run
end