# Demo Notes 

	$env:DEMO_SSH_KEY='C:\Users\Administrator\.ssh\stack.pem'
	$env:DEMO_IP='10.0.0.81'
	$env:DEMO_NODE_NAME='oracle81'

## Provision Oracle

	ssh -i $env:DEMO_SSH_KEY root@$env:DEMO_IP 'echo "10.0.0.10 chefserver" >> /etc/hosts; mkdir -p /etc/chef; touch /etc/chef/encrypted_data_bag_secret; echo "superSECRETencryptionKEY" >> /etc/chef/encrypted_data_bag_secret'
	knife bootstrap $env:DEMO_IP -N $env:DEMO_NODE_NAME -x root -i $env:DEMO_SSH_KEY
	knife node run_list add $env:DEMO_NODE_NAME role[oracle]
	ssh -i $env:DEMO_SSH_KEY root@$env:DEMO_IP 'chef-client --audit-mode enabled'

## Test Oracle

	ssh -i $env:DEMO_SSH_KEY root@$env:DEMO_IP
	su - oracle
	sqlplus demo/demo
	desc players;
	select * from players;

## Manually Reset Oracle Demo

	ssh -i $env:DEMO_SSH_KEY root@$env:DEMO_IP
	su - oracle
	dba

	DROP USER demo CASCADE;
	DROP ROLE role_demo;
	DROP TABLESPACE ts_demo INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS; 
