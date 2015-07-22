name "oracledb"
description "Oracle server role for Centos nodes"
run_list "recipe[base-oracle-db]"
override_attributes(
  :oracle => {
    :ora_base => "/opt/oracle",
    :rdbms => {
      :dbs_root => "/opt/oracle/oradata",
      :dbbin_version => "12c",
      :install_files => [
        "https://s3-eu-west-1.amazonaws.com/oracle-demo/linuxamd64_12102_database_1of2.zip",
        "https://s3-eu-west-1.amazonaws.com/oracle-demo/linuxamd64_12102_database_2of2.zip"
      ],
      :latest_patch => {:is_installed => true},
      :dbs => {:DB1 => false},
      :sys_pw => "demo",
      :system_pw => "demo",
      :dbsnmp_pw => "demo",
      :dbconsole => {:sysman_pw => "demo"}
    },
    :cliuser => {
      :edb => "oracle",
      :edb_item => "server_pw"
    },
    :user => {
      :edb => "oracle",
      :edb_item => "client_pw"
    }
  },
  :base_oracle_db => {
    :hostname => "oracledb",
    :internal_ip => "10.0.0.80",
    :schema => {
      :tablespace => {
        :name => 'ts_demo',
        :directory => '/home/oracle/demo',
        :datafile => '/home/oracle/demo/ts_demo.dbf'
      },
      :role => { :name => "role_demo" },
      :sys => {
        :name => "sys",
        :password => "demo",
        :locations => "create_user_db"
      },
      :user => {
        :name => "demo",
        :password => "demo",
        :locations => "oracle_scripts"
      }
    },
    :flyway => { :version => '3.2.1'}
  }
)