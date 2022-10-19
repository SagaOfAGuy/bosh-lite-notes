# VirtualBox Deployment Test

## Installation

1. Make sure `virtualbox` and `virtualbox-ext-pack` is installed

```bash
sudo apt install virtualbox virtualbox-ext-pack
```

2. Confirm that `virtualbox` has installed successfully

```bash
VBoxManage --version

6.1.36_Ubuntur152435
```
## Workspace Creation
3. Create workspace folder

```bash
mkdir -p ~/workspace/deployment
```

4. Clone bosh deployment folder to local `~/workspace/deployment` folder which will be the master workspace deployment folder that houses files needed to create our test deployment environment.

```bash
git clone https://github.com/cloudfoundry/bosh-deployment ~/workspace/bosh-deployment
```

5. Create a separate local deployment folder for our VirtualBox test deployment and `cd` to this folder
```bash
mkdir -p ~/deployments/vbox && cd ~/deployments/vbox
```
## Test Environment Creation
6. Create a `bosh` VirtualBox environment. Replace `$IP`,`$GATEWAY_IP` and `$CIDR_IP` with desired IP addresses, and `$NAME` with desired environment name

```bash
bosh create-env ~/workspace/bosh-deployment/bosh.yml \
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
  -v internal_ip=$IP \
  -v internal_gw=$GATEWAY_IP \
  -v internal_cidr=$CIDR_IP \
  -v outbound_network_name=NatNetwork
```
7. Create username and password for test environment

```bash
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`
```

8. Create alias (shorthand name) for created environment. Replace `$IP` with desired IP Address. Ideally should be `$IP` from the `create-env` command. Replace `$ENVIRONMENT_NAME` with desired environment name. 

```bash
bosh alias-env $ENVIRONMENT_NAME -e $IP --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
```

9. Confirm that environment has been registered within `bosh`. Replace `$ENVIRONMENT_NAME` with desired environment name. 

```bash
bosh -e $ENVIRONMENT_NAME env
```
10. Setup local network route to access VM locally
```bash
sudo ip route add   10.244.0.0/16 via 192.168.56.6
```