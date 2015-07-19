# download
remote_file "#{node['oracle']['ora_base']}/flyway-commandline-#{node['base-oracle-db']['flyway']['version']}-linux-x64.tar.gz" do
  source "https://bintray.com/artifact/download/business/maven/flyway-commandline-#{node['base-oracle-db']['flyway']['version']}-linux-x64.tar.gz"
  user "oracle"
  action :create
  notifies :run, "execute[unpack #{node['oracle']['ora_base']}/flyway-commandline-#{node['base-oracle-db']['flyway']['version']}-linux-x64.tar.gz]", :immediately
  not_if do ::File.exists?("#{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}/conf/flyway.conf") end
end

#unpack
execute "unpack #{node['oracle']['ora_base']}/flyway-commandline-#{node['base-oracle-db']['flyway']['version']}-linux-x64.tar.gz" do
  command "/bin/tar xzf #{node['oracle']['ora_base']}/flyway-commandline-#{node['base-oracle-db']['flyway']['version']}-linux-x64.tar.gz"
  cwd "#{node['oracle']['ora_base']}"
  action :nothing
  notifies :run, "execute[chown_#{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}]", :immediately 
end

#delete archive 
file "#{node['oracle']['ora_base']}/flyway-commandline-#{node['base-oracle-db']['flyway']['version']}-linux-x64.tar.gz" do
  action :delete
end

#change ownersip
execute "chown_#{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}" do
  command "/bin/chown oracle:oinstall #{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}"
  cwd "#{node['oracle']['ora_base']}"
  action :nothing
  notifies :create, "template[#{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}/conf/flyway.conf]", :immediately 
end

#configure flyway
template "#{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}/conf/flyway.conf" do
  source 'flyway.conf.erb'
  owner 'oracle'
  action :nothing
  notifies :run, "execute[symlink]", :immediately
end

#create symlink to the jdbc driver
execute "symlink" do
  command "ln -s #{node['oracle']['ora_base']}/12R1/jdbc/lib/ojdbc6.jar #{node['oracle']['ora_base']}/flyway-#{node['base-oracle-db']['flyway']['version']}/drivers/ojdbc6.jar"
  cwd "#{node['oracle']['ora_base']}"
  action :nothing
end
