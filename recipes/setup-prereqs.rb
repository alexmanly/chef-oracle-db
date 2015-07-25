#Set up FQDN and hosts file
template "/etc/sysconfig/network" do
  source "network.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "set_hostname" do
  command "hostname " + node[:base_oracle_db][:hostname]
  not_if "hostname | grep " + node[:base_oracle_db][:hostname]
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

# Set-up secret key
directory '/etc/chef'

file '/etc/chef/encrypted_data_bag_secret' do
  content node[:base_oracle_db][:encryption_key]
end

# disable require tty
node.default['authorization']['sudo']['sudoers_defaults'] = [
  '!requiretty',
  '!visiblepw',
  'always_set_home',
  'env_reset',
  'env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
  'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
  'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
  'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
  'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
  'env_keep += "HOME"',
  'secure_path = /sbin:/bin:/usr/sbin:/usr/bin'
]
include_recipe 'sudo'

# Set-up firewall

# bash 'iptables_for_was_console' do
#   code <<-EOH
#     /sbin/iptables -A INPUT -p tcp --dport 1521 -j ACCEPT
#     /sbin/iptables -A INPUT -p tcp --dport 5500 -j ACCEPT
#     /sbin/service iptables save
#     EOH
# end

service 'iptables' do
  action :stop
end

swapfile 'create swapfile' do
  swapfile_directory node[:base_oracle_db][:swapfile_directory]
  swapfile_name node[:base_oracle_db][:swapfile_name]
  count_blocks '204800'
end

partition 'create partition' do
  device_id node[:base_oracle_db][:device_id]
  partition_number node[:base_oracle_db][:partition_number]
  mount_dir node[:oracle][:ora_base]
  partition_size node[:base_oracle_db][:partition_size]
  fs_type node[:base_oracle_db][:fs_type]
  action :partition_and_mount
end