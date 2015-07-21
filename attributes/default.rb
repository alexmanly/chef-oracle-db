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
#default['oracle']['ora_base'] = '/opt/oracle'
default['base-oracle-db']['fs_type'] = 'ext4'

default['base-oracle-db']['schema']['tablespace']['name'] = 'ts_demo'
default['base-oracle-db']['schema']['tablespace']['directory'] = '/home/oracle/demo'
default['base-oracle-db']['schema']['tablespace']['datafile'] = node['base-oracle-db']['schema']['tablespace']['directory'] + '/ts_demo.dbf'
default['base-oracle-db']['schema']['role']['name']= 'role_demo'
default['base-oracle-db']['schema']['user']['name'] = 'demo'
default['base-oracle-db']['schema']['user']['password'] = 'demo'

default['base-oracle-db']['scripts']['script_dir_name'] = 'oracle_scripts'
default['base-oracle-db']['scripts']['cache_script_path'] = Chef::Config[:file_cache_path] + '/' + default['base-oracle-db']['scripts']['script_dir_name']
default['base-oracle-db']['scripts']['scripts'] = ['V001__schema.sql', 'V002__data.sql']

default['base-oracle-db']['flyway']['version'] = '3.2.1'
default['base-oracle-db']['flyway']['conf'] = {
	url: 'jdbc:oracle:thin:@//' + default['base-oracle-db']['hostname'] + ':1521/DB1',
	user: default['base-oracle-db']['schema']['user']['name'] ,
	password: default['base-oracle-db']['schema']['user']['password'],
	locations: 'filesystem:' + default['base-oracle-db']['scripts']['cache_script_path']
}