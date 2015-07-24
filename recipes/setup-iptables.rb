# bash 'iptables_for_was_console' do
#   code <<-EOH
#     /sbin/iptables -A INPUT -p tcp --dport 1521 -j ACCEPT
#     /sbin/iptables -A INPUT -p tcp --dport 5500 -j ACCEPT
#     /sbin/service iptables save
#     EOH
# end

service 'iptables' do
  action :stop
end