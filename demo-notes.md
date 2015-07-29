# Demo Notes 

	export DEMO_SSH_KEY='C:\Users\Administrator\.ssh\stack.pem'
	export DEMO_IP=10.0.0.81
	export DEMO_NODE_NAME=oracle81

## Provision Oracle

	ssh -i $DEMO_SSH_KEY root@$DEMO_IP 'echo "10.0.0.10 chefserver" >> /etc/hosts; mkdir -p /etc/chef; touch /etc/chef/encrypted_data_bag_secret; echo "superSECRETencryptionKEY" >> /etc/chef/encrypted_data_bag_secret'
	knife bootstrap $DEMO_IP -N $DEMO_NODE_NAME -x root -i $DEMO_SSH_KEY
	knife node run_list add $DEMO_NODE_NAME role[oracle]
	ssh -i $DEMO_SSH_KEY root@$DEMO_IP 'chef-client --audit-mode enabled'

## Test Oracle

	ssh -i $DEMO_SSH_KEY root@$DEMO_IP
	su - oracle
	sqlplus demo/demo
	desc players;
	select * from players;

## Manually Reset Oracle Demo

	ssh -i $DEMO_SSH_KEY root@$DEMO_IP
	su - oracle
	dba

	DROP USER demo CASCADE;
	DROP ROLE role_demo;
	DROP TABLESPACE ts_demo INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS; 
