#!/bin/bash

# Grab the bosh executable
wget https://github.com/cloudfoundry/bosh-cli/releases/download/v7.0.1/bosh-cli-7.0.1-linux-amd64

# Make executable
chmod +x bosh-cli-7.0.1-linux-amd64 && sudo mv bosh-cli-7.0.1-linux-amd64 bosh && sudo mv bosh /usr/bin

# Check Bosh Version
bosh -v

# Install dependencies
sudo apt-get install -y build-essential zlib1g-dev ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3

# Install Virtualbox and Virtualbox extension pack
sudo apt install virtualbox virtualbox-ext-pack

# Check VirtualBox version
VBoxManage --version
