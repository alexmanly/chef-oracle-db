default[:base_oracle_db][:hostname] = 'oracledb'
default[:base_oracle_db][:hosts] =  {
	'chefserver' => '10.0.0.10', 
	'chefanalytics' => '10.0.0.20',
	'centosweb01' => '10.0.0.30',
	'centosweb02' => '10.0.0.40',
	'loadbalancer' => '10.0.0.50',
	'chefdk' => '10.0.0.60',
	node[:base_oracle_db][:hostname] => node[:ipaddress]
}

default[:base_oracle_db][:encryption_key] = 'superSECRETencryptionKEY'

default[:base_oracle_db][:swapfile_directory] = '/var/cache/swap'
default[:base_oracle_db][:swapfile_name] = 'swapfile'

default[:base_oracle_db][:device_id] = '/dev/xvde'
default[:base_oracle_db][:partition_number] = '2'
default[:base_oracle_db][:partition_size] = '+40G'
#default[:oracle][:ora_base] = '/opt/oracle'
default[:base_oracle_db][:fs_type] = 'ext4'

default[:base_oracle_db][:schema][:tablespace][:name] = 'ts_demo'
default[:base_oracle_db][:schema][:tablespace][:directory] = '/home/oracle/demo'
default[:base_oracle_db][:schema][:tablespace][:datafile] = node[:base_oracle_db][:schema][:tablespace][:directory] + '/ts_demo.dbf'
default[:base_oracle_db][:schema][:role][:name]= 'role_demo'
default[:base_oracle_db][:schema][:user][:name] = 'demo'
default[:base_oracle_db][:schema][:user][:password] = 'demo'
default[:base_oracle_db][:schema][:user][:locations] = 'oracle_scripts'
default[:base_oracle_db][:schema][:sys][:name] = 'sys'
default[:base_oracle_db][:schema][:sys][:password] = 'demo'
default[:base_oracle_db][:schema][:sys][:locations] = 'create_user_db'


default[:base_oracle_db][:flyway][:version] = '3.2.1'
default[:base_oracle_db][:flyway][:conf] = {
	url: "jdbc:oracle:thin:@//#{node[:base_oracle_db][:hostname]}:1521/DB1",
	user: node[:base_oracle_db][:schema][:user][:name] ,
	password: node[:base_oracle_db][:schema][:user][:password],
	locations: 'filesystem:' + Chef::Config[:file_cache_path] + '/' + node[:base_oracle_db][:schema][:sys][:locations]
}