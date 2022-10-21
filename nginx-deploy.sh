#!/bin/bash

# Grab bosh deployment package
git clone https://github.com/cloudfoundry/bosh-deployment ~/workspace/bosh-deployment

# Create deployment folder with virtualbox section
mkdir -p ~/deployments/vbox && cd ~/deployments/vbox

# Create bosh environment
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
  -v director_name=test-env \
  -v internal_ip=192.168.56.6 \
  -v internal_gw=192.168.56.1 \
  -v internal_cidr=192.168.56.0/24 \
  -v outbound_network_name=NatNetwork

# Generate environment credentials
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`

# Create alias to environment
bosh alias-env test-env -e 192.168.56.6 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)

# Sign into environment
bosh -e test-env env

# Update cloud config file
bosh -e $NAME update-cloud-config ~/workspace/bosh-deployment/warden/cloud-config.yml

# Upload stemcell to test environment
bosh -e test-env upload-stemcell --sha1 19355b8bece54930f78077290b7c1562ef45c1ee \
https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-bionic-go_agent?v=1.115

# Clone nginx release
cd ~/workspace
git clone https://github.com/cloudfoundry-community/nginx-release.git
cd nginx-release

# Upload nginx release to environment
bosh -e test-env ur https://github.com/cloudfoundry-community/nginx-release/releases/download/1.21.6/nginx-release-1.21.6.tgz

# Deploy nginx on stemcell
bosh -e test-env -d nginx deploy manifests/nginx-lite.yml

# Add route to make nginx server accessible
sudo ip route add 10.244.0.0/24 via 192.168.56.6
