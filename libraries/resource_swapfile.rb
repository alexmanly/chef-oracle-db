require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class SwapFile < Chef::Resource::LWRPBase
      provides :swapfile

      self.resource_name = :swapfile
      actions :create
      default_action :create

      attribute :swapfile_directory, :name_attribute => true, :kind_of => String
      attribute :swapfile_name, :name_attribute => false, :kind_of => String
      attribute :count_blocks, :name_attribute => false, :kind_of => String

    end
  end
end