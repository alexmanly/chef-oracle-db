name "oracledb"
description "Oracle server role for Centos nodes"
run_list "recipe[base-oracle-db]"
override_attributes(
  "oracle" => {
    "ora_base" => "/opt/oracle",
    "rdbms"=> {
      "dbs_root" => "/opt/oracle/oradata",
      "dbbin_version" => "12c",
      "install_files" => [
        "https://s3-eu-west-1.amazonaws.com/oracle-demo/linuxamd64_12102_database_1of2.zip",
        "https://s3-eu-west-1.amazonaws.com/oracle-demo/linuxamd64_12102_database_2of2.zip"
      ],
      "latest_patch" => {"is_installed" => true},
      "dbs" => {"DB1" => false},
      "sys_pw" => "demo",
      "system_pw" => "demo",
      "dbsnmp_pw" => "demo",
      "dbconsole" => {"sysman_pw" => "demo"}
    },
    "cliuser" => {
        "edb" => "oracle",
        "edb_item" => "server_pw"
    },
    "user" => {
        "edb" => "oracle",
        "edb_item" => "client_pw"
    }
  },
  "base-oracle-db" => {
    "hostname" => "oracledb",
    "internal_ip" => "10.0.0.80"
  }
)