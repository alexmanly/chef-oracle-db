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

To bootstrap the node, make the node able to talk to the chefserver on it's internal IP and then, create the data bags and add the role to the node using the following commands:

	$env:DEMO_SSH_KEY='C:\Users\Administrator\.ssh\stack.pem'
	$env:DEMO_IP='10.0.0.80'
	$env:DEMO_NODE_NAME='oracledb'

	ssh -i $env:DEMO_SSH_KEY root@$env:DEMO_IP 'echo "10.0.0.10 chefserver" >> /etc/hosts; mkdir -p /etc/chef; touch /etc/chef/encrypted_data_bag_secret; echo "superSECRETencryptionKEY" >> /etc/chef/encrypted_data_bag_secret'

	knife data_bag create oracle
	knife data_bag from file oracle client_pw.json
	knife data_bag from file oracle server_pw.json

	knife role from file oracle.rb

	knife bootstrap $env:DEMO_IP -N $env:DEMO_NODE_NAME -x root -i $env:DEMO_SSH_KEY -r '''role[oracle]'''
	
From the Workstation log into the node and run chef-client:

	ssh -i $env:DEMO_SSH_KEY root@$env:DEMO_IP

	chef-client

	# Get a cup of tea, or two....this takes about 55 mins to complete. 

Test the installation
	
	su - oracle -c 'echo "select 123 from dual;" | sqlplus / as sysdba'

	SQL*Plus: Release 12.1.0.2.0 Production on Thu Jul 16 22:55:12 2015

	Copyright (c) 1982, 2014, Oracle.  All rights reserved.


	Connected to:
	Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
	With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options

	SYS@DB1>
	       123
	----------
	       123

	SYS@DB1>Disconnected from Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
	With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options

Login to the Oracle EM using TestKitchen

	https://192.168.56.44:5500/em/login sys/demo
