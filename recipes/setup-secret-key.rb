directory '/etc/chef'

file '/etc/chef/encrypted_data_bag_secret' do
  content 'superSECRETencryptionKEY'
end