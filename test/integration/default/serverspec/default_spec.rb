require 'spec_helper'

describe user('oracle') do
  it { should exist }
  it { should belong_to_group 'oinstall' }
  it { should have_home_directory '/home/oracle' }
  it { should have_login_shell '/bin/ksh' }
end

describe service('oracle') do
  it { should be_enabled }
  it { should be_running }
end

describe port(1521) do
  it { should be_listening }
end

describe port(5500) do
  it { should be_listening }
end

sys_oracle_command='su - oracle -c \'echo "select 123 from dual;" | /opt/oracle/12R1/bin/sqlplus / as sysdba\''
describe command(sys_oracle_command) do
  its(:stdout) { should match /123\n----------/ }
end

demo_oracle_command='su - oracle -c \'echo "select 456 from dual;" | /opt/oracle/12R1/bin/sqlplus demo/demo\''
describe command(demo_oracle_command) do
  its(:stdout) { should match /456\n----------/ }
end

# web interface to test:
# https://192.168.56.44:5500/em/login