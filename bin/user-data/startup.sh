#!/bin/sh
# This scripts accepts 1 argument (local | songbird).

# Handle build dependencies.
apt -y install git curl
snap install go --classic

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
export REPO_URL=https://gitlab.com/flarenetwork/flare.git
export GOPATH=$(go env GOPATH)

# Create all directories the repo depends on.
mkdir -p ${FLARENETWORK_ROOT}

# Clone/Pull repo from gitlab which creates ${FLARE_ROOT}.
cd ${FLARENETWORK_ROOT}
if [ ! -d ${FLARE_ROOT} ]; then
    git clone --no-checkout ${REPO_URL}
else
    cd ${FLARE_ROOT}
    git pull ${REPO_URL}
fi

cd ${FLARE_ROOT}
git checkout master
# compile.sh options: local | songbird
./compile.sh ${1} 
./cmd/${1}.sh
