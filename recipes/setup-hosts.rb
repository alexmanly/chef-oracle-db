template "/etc/sysconfig/network" do
  source "network.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "set_hostname" do
  command "hostname " + node[:base_oracle_db][:hostname]
end

hostsfile_entry '127.0.0.1' do
  hostname  node[:base_oracle_db][:hostname]
  unique    true
  aliases   ['localhost']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :update
end

node[:base_oracle_db][:hosts].each do |host, ip|
  hostsfile_entry ip do
    hostname  host
    unique    true
    aliases   ["#{host}.local"]
    comment   'Append by Recipe base-oracle-db::setup-hostsfile'
    action    :create
  end
end