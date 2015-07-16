# base-oracle-db

This cookbook can be used to demo setting up an Oracle DB server.

This cookbook has been tested with an AWS Marketplace Centos AMI.

To create the instace follow these instructions:

	AWS Marketplace search and select - CentOS 6 (x86_64) - with Updates

	Select - m3.medium

	Network - vpc-93a22ff6
	Subnet - subnet-4098fe37
	Auto assign public IP = enable
	Network Interfaces Primary IP = 10.0.0.80

	Storage size - 50Gb
	Delete on termination - true

	Tag Name - <your key pair name> <customer> Demo Oracle DB

	Security Group - sg-007d7465 - ChefSecurityGroup (plus 1521 and 5500 on TCP)

	Key Pair - <your key pair name>

To bootstrap the node and add the role to the node run the following commands:

    knife role from file oracledb.rb

	ssh -i <your private key> root@10.0.0.80 'echo "10.0.0.10 chefserver" >> /etc/hosts; mkdir -p /etc/chef; touch /etc/chef/encrypted_data_bag_secret; echo "superSECRETencryptionKEY" >> /etc/chef/encrypted_data_bag_secret'

	knife bootstrap 10.0.0.80 -N oracledb -x root -i <your private key>
	
	knife node run_list add oracledb role[oracledb]
	
From the Workstation log into the node and run chef-client:

	ssh -i <your private key> root@10.0.0.80

	chef-client

