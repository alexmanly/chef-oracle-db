require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class SwapFile < Chef::Provider::LWRPBase
      provides :swapfile if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
      	dir = new_resource.swapfile_directory
		file = new_resource.swapfile_name
		count = new_resource.count_blocks

		directory dir 

		execute "create_swap_file" do
		  command "dd if=/dev/zero of=#{dir}/#{file} bs=1024 count=#{new_resource.count_blocks}"
		  not_if "/sbin/swapon -s  | grep #{dir}/#{file}"
		end

		file "#{dir}/#{file}" do
		  mode '0600'
		end

		execute "mkswap" do
		  command "/sbin/mkswap #{dir}/#{file}"
		  not_if "/sbin/swapon -s  | grep #{dir}/#{file}"
		end

		execute "swapon" do
		  command "/sbin/swapon #{dir}/#{file}"
		  not_if "/sbin/swapon -s  | grep #{dir}/#{file}"
		end

		execute "fstab_swapfile" do
		  command '/bin/echo "#{dir}/#{file}       none                swap   sw            0 0" >> /etc/fstab'
		  not_if do ::File.readlines("/etc/fstab").grep(/"#{file}"/).any? end
		end
      end
    end
  end
end