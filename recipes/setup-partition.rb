mount_point = node['base-oracle-db']['mount_point']
device = node['base-oracle-db']['device_id'] + node['base-oracle-db']['partition_number']

directory "#{mount_point}"

package 'parted' do
  action :upgrade
end

bash "fdisk_#{device}" do
	user 'root'
	cwd '/tmp'
  not_if "/sbin/fdisk -l #{node['base-oracle-db']['device_id']} | grep #{device}"
	## Setup the partition
	code <<-EOF
/sbin/fdisk /dev/xvde <<EOC || true
n
p
#{node['base-oracle-db']['partition_number']}

#{node['base-oracle-db']['partition_size']}
w
EOC
EOF
end

execute "partx_#{node['base-oracle-db']['device_id']}" do
  command "partx -a #{node['base-oracle-db']['device_id']}"
end

execute "partprobe_#{device}" do
  command "partprobe #{device}"
end

execute 'mkfs' do
  command "mkfs -t #{node['base-oracle-db']['fs_type']} #{device}"
  # only if it's not mounted already
  not_if "grep -qs #{node['base-oracle-db']['mount_point']} /proc/mounts"
end

mount "#{mount_point}" do
  device "#{device}"
  action [:enable, :mount]
end
