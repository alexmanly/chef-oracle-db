#
# Cookbook Name:: base-oracle-db
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'base-oracle-db::setup-hosts'
include_recipe 'base-oracle-db::setup-secret-key'
include_recipe 'base-oracle-db::setup-sudoers'
include_recipe 'base-oracle-db::setup-iptables'
include_recipe 'base-oracle-db::setup-swapfile'
include_recipe 'base-oracle-db::setup-partition'
include_recipe 'oracle::default'
include_recipe 'oracle::logrotate_alert_log'
include_recipe 'oracle::logrotate_listener'
include_recipe 'oracle::createdb'