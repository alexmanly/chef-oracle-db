require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class Partition < Chef::Provider::LWRPBase
      provides :partition if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :partition_and_mount do
      	device = new_resource.device_id + new_resource.partition_number

		directory new_resource.mount_dir

		package 'parted' do
		  action :upgrade
		end

		bash "fdisk_#{device}" do
			user 'root'
			cwd '/tmp'
			notifies :run, "execute[partx_#{new_resource.device_id}]", :immediately
		  	not_if "/sbin/fdisk -l #{new_resource.device_id} | grep #{device}"
			## Setup the partition
			code <<-EOF
		/sbin/fdisk #{new_resource.device_id} <<EOC || true
		n
		p
		#{new_resource.partition_number}

		#{new_resource.partition_size}
		w
		EOC
		EOF
		end

		execute "partx_#{new_resource.device_id}" do
		  command "partx -a #{new_resource.device_id}"
		  notifies :run, "execute[partprobe_#{device}]", :immediately
		  action :nothing
		end

		execute "partprobe_#{device}" do
		  command "partprobe #{device}"
		  notifies :run, "execute[mkfs]", :immediately
		  action :nothing
		end

		execute 'mkfs' do
		  command "mkfs -t #{new_resource.fs_type} #{device}"
		  action :nothing
		end

		mount "#{new_resource.mount_dir}" do
		  device "#{device}"
		  action [:enable, :mount]
		end
      end
    end
  end
end