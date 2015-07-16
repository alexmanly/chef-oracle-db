directory '/var/cache/swap' 

execute "create_swap_file" do
  command "dd if=/dev/zero of=/var/cache/swap/swapfile bs=1024 count=204800"
  not_if "/sbin/swapon -s  | grep /var/cache/swap/swapfile"
end

file '/var/cache/swap/swapfile' do
  mode '0600'
end

execute "mkswap" do
  command "/sbin/mkswap /var/cache/swap/swapfile"
  not_if "/sbin/swapon -s  | grep /var/cache/swap/swapfile"
end

execute "swapon" do
  command "/sbin/swapon /var/cache/swap/swapfile"
  not_if "/sbin/swapon -s  | grep /var/cache/swap/swapfile"
end

execute "swapon" do
  command '/bin/echo "/var/cache/swap/swapfile       none                swap   sw            0 0" >> /etc/fstab'
  not_if "/sbin/swapon -s  | grep /var/cache/swap/swapfile"
end