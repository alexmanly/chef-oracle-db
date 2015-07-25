directory node[:base_oracle_db][:schema][:tablespace][:directory] do
  owner node[:oracle][:user][:edb]
  group 'oinstall'
end

sqlplus 'sqlplus_create_user_db' do
  location node[:base_oracle_db][:schema][:sys][:locations]
  user node[:base_oracle_db][:schema][:sys][:name]
  password node[:base_oracle_db][:schema][:sys][:password]
  install_dir node[:oracle][:ora_base]
  owner node[:oracle][:user][:edb]
  group 'oinstall'
  sysdba 'as sysdba'
  oracle_sid 'DB1'
  oracle_env '12R1'
  action :run
  not_if "su - oracle -c 'echo \"select 123 from dual;\" | sqlplus demo/demo' | grep 123"
end