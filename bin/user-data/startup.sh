#!/bin/sh
# This scripts accepts 1 argument (local | songbird).

# Handle build dependencies.
apt -y install git curl
snap install go --channel=1.15/stable --classic

# Download the node installation script only if node is not installed.
which node
if [ ${?} -eq 1 ]; then
  curl -sL https://deb.nodesource.com/setup_10.x | bash -
fi
apt -y install nodejs
npm install --global yarn

# Complete installation of dependencies
apt update
apt -y install gcc g++ curl jq

# Define all paths and other environment variables that are needed.
export REPO_ROOT=${HOME}/go
export FLARENETWORK_ROOT=${REPO_ROOT}/src/gitlab.com/flarenetwork
export FLARE_ROOT=${FLARENETWORK_ROOT}/flare
export FLARE_REPO_URL=https://gitlab.com/flarenetwork/flare.git
export AVALABS_ROOT=${REPO_ROOT}/src/github.com/ava-labs
export AVALANCHE_ROOT=${AVALABS_ROOT}/avalanchego
export AVALANCHE_REPO_URL=https://github.com:ava-labs/avalanchego.git
export GOPATH=$(go env GOPATH)

# Create all directories the repo depends on.
mkdir -p ${FLARENETWORK_ROOT}
mkdir -p ${AVALANCHE_ROOT}

# cd 
# git clone 

# Clone/Pull repo from gitlab for ${FLARE_ROOT}.
cd ${FLARENETWORK_ROOT}
if [ ! -d ${FLARE_ROOT} ]; then
    git clone --no-checkout ${FLARE_REPO_URL}
else
    cd ${FLARE_ROOT}
    git pull ${FLARE_REPO_URL}
fi

# Clone/Pull repo from github for ${AVALANCHE_ROOT}
cd ${AVALABS_ROOT}
if [ ! -d ${AVALANCHE_ROOT} ]; then
    git clone --no-checkout ${AVALANCHE_REPO_URL}
else
    cd ${AVALANCHE_ROOT}
    git pull ${AVALANCHE_REPO_URL}
fi

cd ${FLARE_ROOT}
git checkout master
# compile.sh options: local | songbird
./compile.sh ${1} 
./cmd/${1}.sh
