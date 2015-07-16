dir = node['base-oracle-db']['swapfile_directory']
file = node['base-oracle-db']['swapfile_name']

directory dir 

execute "create_swap_file" do
  command "dd if=/dev/zero of=#{dir}/#{file} bs=1024 count=204800"
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