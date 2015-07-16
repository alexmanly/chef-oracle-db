default['base-oracle-node']['hostname'] = 'oracledb1'
default['base-oracle-node']['hosts'] =  {
	'chefserver' => '10.0.0.10', 
	'chefanalytics' => '10.0.0.20',
	'centosweb01' => '10.0.0.30',
	'centosweb02' => '10.0.0.40',
	'loadbalancer' => '10.0.0.50',
	'chefdk' => '10.0.0.60',
	node['base-oracle-node']['hostname'] => '10.0.0.90'
}
default['base-oracle-node']['partition_size'] = '2G'
default['base-oracle-node']['mount_point'] = '/opt/oracle'
default['base-oracle-node']['device_id'] = '/dev/xvde2'
default['base-oracle-node']['fs_type'] = 'ext4'