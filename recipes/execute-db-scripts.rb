flyway "install_flyway_#{node['oracle']['ora_base']}" do
  install_dir node['oracle']['ora_base']
  version node['base-oracle-db']['flyway']['version']
  owner 'oracle'
  group 'oinstall'
  action :install
end

flyway "migrate_flyway_#{node['base-oracle-db']['flyway']['locations']}" do
  location node['base-oracle-db']['flyway']['locations']
  url 'jdbc:oracle:thin:@//' + node['base-oracle-db']['hostname'] + ':1521/DB1'
  user node['base-oracle-db']['schema']['user']['name']
  password node['base-oracle-db']['schema']['user']['password']
  install_dir "#{node['oracle']['ora_base']}"
  owner 'oracle'
  action :run
end