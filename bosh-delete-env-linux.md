# Delete Bosh Environment

1. Display all `bosh` environments. Locate environment that you want to delete. 
```bash
School@pop-os:~/Documents$ bosh envs
```
```bash
URL           Alias  
192.168.56.6  vbox  

1 environments

Succeeded
```

2. Unalias the desired environment
```bash
bosh unalias-env $ENVIRONMENT_NAME
```

3. Check `bosh` environments to confirm unalias:
```bash
School@pop-os:~/Documents$ bosh envs
```
```bash
URL  Alias  

0 environments

Succeeded
```

4. Delete `bosh` environment. Locate the `bosh create-env` command in the bash `history` and replace `bosh create-env` with `bosh delete-env` and the following parameters.
```bash
cd ~/deployments/vbox && 
bosh delete-env ~/workspace/bosh-deployment/bosh.yml \
  --state ./state.json \
  -o ~/workspace/bosh-deployment/virtualbox/cpi.yml \
  -o ~/workspace/bosh-deployment/virtualbox/outbound-network.yml \
  -o ~/workspace/bosh-deployment/bosh-lite.yml \
  -o ~/workspace/bosh-deployment/bosh-lite-runc.yml \
  -o ~/workspace/bosh-deployment/uaa.yml \
  -o ~/workspace/bosh-deployment/credhub.yml \
  -o ~/workspace/bosh-deployment/jumpbox-user.yml \
  --vars-store ./creds.yml \
  -v director_name=$NAME \
  -v internal_ip=192.168.56.6 \
  -v internal_gw=192.168.56.1 \
  -v internal_cidr=192.168.56.0/24 \
  -v outbound_network_name=NatNetwork
```

**NOTE:** If Network route still exists, check network route, and unassign the route. 
```bash
route -n
```

Delete route: 
```bash
sudo route del -net $DESTINATION gw $GATEWAY netmask $NETMASK dev $INTERFACE
```

# Delete Bosh deployment
```bash
bosh -d $DEPLOYMENT_NAME delete-deployment
```
