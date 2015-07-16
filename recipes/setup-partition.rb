mount_point = node['base-oracle-node']['mount_point']
device_id = node['base-oracle-node']['device_id']
fs_type = node['base-oracle-node']['fs_type']

directory "#{mount_point}"

package 'parted' do
  action :upgrade
end

bash "fdisk_/dev/xvde" do
	user 'root'
	cwd '/tmp'
	## Setup the partition
	code <<-EOF
/sbin/fdisk /dev/xvde <<EOC
n
p
2

+#{node['base-oracle-node']['partition_size']}
w
EOC
EOF
end

execute "partprobe_#{device_id}" do
  command "partprobe #{device_id}"
end

execute 'mkfs' do
  command "mkfs -t #{fs_type} #{device_id}"
  # only if it's not mounted already
  not_if "grep -qs #{node['base-oracle-node']['mount_point']} /proc/mounts"
end

mount "#{mount_point}" do
  device "#{device_id}"
  fstype "#{fs_type}"
  options 'noatime,nobootwait'
  action [:enable, :mount]
end

execute "update_fstab" do
  command '/bin/echo "#{device_id}       #{mount_point}                #{fs_type}   defaults            1 2" >> /etc/fstab'
  not_if do ::File.readlines("/etc/fstab").grep(/xvde2/).any? end
end
