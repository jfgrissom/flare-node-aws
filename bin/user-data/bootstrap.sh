#!/bin/bash

# After this script is run you'll need to create a user 
# then run setup-user-env.sh

GO_VERSION=1.16

echo "- Installing Dependencies:"
apt -y install git curl

echo "- Checking for installed version of Go:"
go version | grep ${GO_VERSION}
if [ ${?} -eq 1 ]; then
    apt remove go
    apt remove golang-go
    snap remove go
fi
echo "- Installing Go:"
snap install go --channel=${GO_VERSION}/stable --classic

echo "- Checking for installed version of NodeJS:"
node --version | grep v10
if [ ${?} -eq 1 ]; then
    apt remove nodejs
fi
echo "- Installing NodeJS:"
snap install node --channel=10/stable --classic
npm config set update-notifier false
npm config set scripts-prepend-node-path true

echo "- Installing Yarn:"
npm install --global yarn

echo "- Updating System:"
apt update

echo "- Completing Installation of Dependencies:"
apt -y install gcc g++ curl jq net-tools

echo "- Creating Flare User:"
useradd -m -s /bin/bash flare
