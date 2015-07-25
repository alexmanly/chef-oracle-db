device = node[:base_oracle_db][:device_id] + node[:base_oracle_db][:partition_number]

directory node[:oracle][:ora_base]

package 'parted' do
  action :upgrade
end

bash "fdisk_#{device}" do
	user 'root'
	cwd '/tmp'
  not_if "/sbin/fdisk -l #{node[:base_oracle_db][:device_id]} | grep #{device}"
	## Setup the partition
	code <<-EOF
/sbin/fdisk /dev/xvde <<EOC || true
n
p
#{node[:base_oracle_db][:partition_number]}

#{node[:base_oracle_db][:partition_size]}
w
EOC
EOF
end

execute "partx_#{node[:base_oracle_db][:device_id]}" do
  command "partx -a #{node[:base_oracle_db][:device_id]}"
  not_if "/sbin/fdisk -l #{node[:base_oracle_db][:device_id]} | grep #{device}"
end

execute "partprobe_#{device}" do
  command "partprobe #{device}"
  not_if "/sbin/fdisk -l #{node[:base_oracle_db][:device_id]} | grep #{device}"
end

execute 'mkfs' do
  command "mkfs -t #{node[:base_oracle_db][:fs_type]} #{device}"
  # only if it's not mounted already
  not_if "grep -qs #{node[:oracle][:ora_base]} /proc/mounts"
end

mount "#{node[:oracle][:ora_base]}" do
  device "#{device}"
  action [:enable, :mount]
end
