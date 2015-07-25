#
# Cookbook Name:: base-oracle-db
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'base-oracle-db::setup-prereqs'
include_recipe 'oracle::default'
include_recipe 'oracle::logrotate_alert_log'
include_recipe 'oracle::logrotate_listener'
node[:oracle][:rdbms][:dbs].each do | dbs_name, bool |
  unless ::File.directory?("#{node[:oracle][:ora_base]}/admin/#{dbs_name}")
    include_recipe 'oracle::createdb'
  end
end
include_recipe 'base-oracle-db::create-user-db'
include_recipe 'base-oracle-db::execute-db-scripts'
include_recipe 'base-oracle-db::audit-oracle'