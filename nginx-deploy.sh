#!/bin/bash

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
