require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class SqlPlus < Chef::Resource::LWRPBase
      provides :sqlplus

      self.resource_name = :sqlplus
      actions :run
      default_action :run

      attribute :location, :name_attribute => true, :kind_of => String
      attribute :user, :name_attribute => false, :kind_of => String
      attribute :password, :name_attribute => false, :kind_of => String
      attribute :install_dir, :name_attribute => false, :kind_of => String
      attribute :owner, :name_attribute => false, :kind_of => String
      attribute :group, :name_attribute => false, :kind_of => String
      attribute :sysdba, :name_attribute => false, :kind_of => String
      attribute :oracle_sid, :name_attribute => false, :kind_of => String
      attribute :oracle_env, :name_attribute => false, :kind_of => String
    end
  end
end