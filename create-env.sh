#!/bin/bash

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
bosh -e test-env update-cloud-config ~/workspace/bosh-deployment/warden/cloud-config.yml
