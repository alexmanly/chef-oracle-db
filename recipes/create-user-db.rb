sql_script = Chef::Config[:file_cache_path] + '/createdb.sql'

template sql_script do
  source "createdb.erb"
  owner "oracle"
  group "oinstall"
  mode "0644"
end

directory "#{node['base-oracle-db']['schema']['tablespace']['directory']}" do
  user 'oracle'
  group 'oinstall'
end

execute "create_user_db" do
  command "#{node['oracle']['ora_base']}/12R1/bin/sqlplus / as sysdba < " + sql_script
  user 'oracle'
  group 'oinstall'
  cwd '/tmp'
  environment(
	'ORACLE_BASE' => node['oracle']['ora_base'],
	'ORACLE_HOME' => node['oracle']['ora_base'] + '/12R1',
	'ORACLE_SID' => 'DB1',
	'ORACLE_UNQNAME' => 'DB1',
	'ORA_ENV'=> '12R1'
  )
end