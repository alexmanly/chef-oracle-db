require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class Flyway < Chef::Resource::LWRPBase
      provides :flyway

      self.resource_name = :flyway
      actions :run, :install
      default_action :run

      attribute :location, :name_attribute => true, :kind_of => String
      attribute :url, :name_attribute => true, :kind_of => String
      attribute :user, :name_attribute => true, :kind_of => String
      attribute :password, :name_attribute => true, :kind_of => String
      attribute :install_dir, :name_attribute => true, :kind_of => String
      attribute :version, :name_attribute => true, :kind_of => String
      attribute :owner, :name_attribute => true, :kind_of => String
      attribute :group, :name_attribute => true, :kind_of => String
    end
  end
end