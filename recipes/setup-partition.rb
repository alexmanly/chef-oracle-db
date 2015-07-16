bash "fdisk_/dev/xvde" do
	user 'root'
	cwd '/tmp'
	ignore_failure true
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

directory '/opt/oracle'

execute "yum_install_parted" do
  command "/usr/bin/yum -y install parted"
end

execute "partprobe_/dev/xvde2" do
  command "partprobe /dev/xvde2"
end

execute "make_file_system_ext4" do
  command "/sbin/mkfs.ext4 /dev/xvde2"
  not_if "/sbin/fdisk -l /dev/xvde | grep xvde2"
end

execute "mount_partition" do
  command "/bin/mount /dev/xvde2 /opt/oracle"
  not_if "/bin/mount | grep /opt/oracle"
end

execute "update_fstab" do
  command '/bin/echo "/dev/xvde2       /opt/oracle                ext4   defaults            1 2" >> /etc/fstab'
  not_if do ::File.readlines("/etc/fstab").grep(/xvde2/).any? end
end
