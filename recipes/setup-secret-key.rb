directory '/etc/chef'

file '/etc/chef/encrypted_data_bag_secret' do
  content node[:base_oracle_db][:encryption_key]
end