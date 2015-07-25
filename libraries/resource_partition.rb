require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class Partition < Chef::Resource::LWRPBase
      provides :partition

      self.resource_name = :partition
      actions :partition_and_mount
      default_action :partition_and_mount

      attribute :device_id, :name_attribute => true, :kind_of => String
      attribute :partition_number, :name_attribute => true, :kind_of => String
      attribute :mount_dir, :name_attribute => true, :kind_of => String
      attribute :partition_size, :name_attribute => true, :kind_of => String
      attribute :fs_type, :name_attribute => true, :kind_of => String

    end
  end
end