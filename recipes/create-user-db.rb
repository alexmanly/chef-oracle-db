sqlplus 'sqlplus_create_user_db' do
  location node[:base_oracle_db][:schema][:sys][:locations]
  user node[:base_oracle_db][:schema][:sys][:name]
  password node[:base_oracle_db][:schema][:sys][:password]
  install_dir node[:oracle][:ora_base]
  owner 'oracle'
  group 'oinstall'
  sysdba 'as sysdba'
  oracle_sid 'DB1'
  oracle_env '12R1'
  action :run
end