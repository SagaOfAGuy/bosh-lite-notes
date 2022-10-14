## Setup Bosh Lite on MacOS 

Documentation: https://bosh.io/docs/bosh-lite/

1. Install `bosh` and `openssl` packagers via `brew` package manager: 

```bash
brew install cloudfoundry/tap/bosh-cli openssl
```

2. Have VirtualBox installed. If not, go to https://www.virtualbox.org/wiki/Downloads

3. Install Bosh Director
```bash
git clone https://github.com/cloudfoundry/bosh-deployment ~/workspace/bosh-deployment
mkdir -p ~/deployments/vbox
cd ~/deployments/vbox
```

4. Create VM specifications: 

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
  -v director_name=bosh-lite \
  -v internal_ip=192.168.1.60 \
  -v internal_gw=192.168.1.1 \
  -v internal_cidr=192.168.1.0/24 \
  -v outbound_network_name=NatNetwork
```

5. Create environment variables for bosh and log into directory

```bash
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`
bosh alias-env vbox -e 192.168.56.6 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
```

6. Test bosh environment

```bash
bosh -e vbox env
```

7. Set local route for ssh for bosh

```bash
sudo route add -net 10.244.0.0/16     192.168.56.6
```


## Deploy 

1. Update cloud config file
```bash
bosh -e vbox update-cloud-config ~/workspace/bosh-deployment/warden/cloud-config.yml
```

2. Upload stemcell

3. Deploy sample deployment

```bash
bosh -e vbox -d zookeeper deploy <(wget -O- https://raw.githubusercontent.com/cppforlife/zookeeper-release/master/manifests/zookeeper.yml)
```
4. Run zookeeper tests

```bash
bosh -e vbox -d zookeeper run-errand smoke-tests
```


## Deleting Stubborn Aliases / Environments 

The `bosh` config file is located in `~/.config/bosh` folder, so clearing it will clear the cache environments. 

```bash
echo "" > ~/.config/bosh
```
