default['base-oracle-db']['hostname'] = 'oracledb'
default['base-oracle-db']['internal_ip'] = '10.0.0.80'
default['base-oracle-db']['hosts'] =  {
	'chefserver' => '10.0.0.10', 
	'chefanalytics' => '10.0.0.20',
	'centosweb01' => '10.0.0.30',
	'centosweb02' => '10.0.0.40',
	'loadbalancer' => '10.0.0.50',
	'chefdk' => '10.0.0.60',
	node['base-oracle-db']['hostname'] => node['base-oracle-db']['internal_ip']
}

default['base-oracle-db']['encryption_key'] = 'superSECRETencryptionKEY'

default['base-oracle-db']['swapfile_directory'] = '/var/cache/swap'
default['base-oracle-db']['swapfile_name'] = 'swapfile'

default['base-oracle-db']['device_id'] = '/dev/xvde'
default['base-oracle-db']['partition_number'] = '2'
default['base-oracle-db']['partition_size'] = '+40G'
default['base-oracle-db']['mount_point'] = '/opt/oracle'
default['base-oracle-db']['fs_type'] = 'ext4'