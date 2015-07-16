template "/etc/sysconfig/network" do
  source "network.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "set_hostname" do
  command "hostname " + node['base-oracle-node']['hostname']
end

hostsfile_entry '127.0.0.1' do
  hostname  node['base-oracle-node']['hostname']
  unique    true
  aliases   ['localhost']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :update
end

hostsfile_entry '10.0.0.10' do
  hostname  'chefserver'
  unique    true
  aliases   ['chefserver.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '10.0.0.20' do
  hostname  'chefanalytics'
  unique    true
  aliases   ['chefanalytics.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '10.0.0.30' do
  hostname  'centosweb01'
  unique    true
  aliases   ['centosweb01.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '10.0.0.40' do
  hostname  'centosweb02'
  unique    true
  aliases   ['centosweb02.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '10.0.0.50' do
  hostname  'loadbalancer'
  unique    true
  aliases   ['loadbalancer.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '10.0.0.60' do
  hostname  'chefdk'
  unique    true
  aliases   ['chefdk.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '10.0.0.90' do
  hostname  node['base-oracle-node']['hostname']
  unique    true
  aliases   [node['base-oracle-node']['hostname'] + '.local']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry '::1' do
  hostname  'ip6-localhost'
  unique    true
  aliases   ['ip6-loopback']
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry 'fe00::0' do
  hostname  'ip6-localnet'
  unique    true
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry 'ff00::0' do
  hostname  'ip6-mcastprefix'
  unique    true
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry 'ff02::1' do
  hostname  'ip6-allnodes'
  unique    true
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry 'ff02::2' do
  hostname  'ip6-allrouters'
  unique    true
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end

hostsfile_entry 'ff02::3' do
  hostname  'ip6-allhosts'
  unique    true
  comment   'Append by Recipe base-oracle-db::setup-hostsfile'
  action    :create
end
