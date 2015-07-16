directory '/etc/chef'

file '/etc/chef/encrypted_data_bag_secret' do
  content node['base-oracle-db']['encryption_key']
end