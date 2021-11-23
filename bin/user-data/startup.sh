#!/bin/sh
# This scripts accepts 1 argument (local | songbird).

echo "Installing Flare Node Dependencies:"
apt -y install git curl

echo "Removing Other Versions of Go:"
go version | grep 1.15
if [ ${?} -eq 1 ]; then
apt remove go
apt remove golang-go
snap remove go
fi
snap install go --channel=1.15/stable --classic

echo "Download and Installing NodeJS:"
which node
if [ ${?} -eq 1 ]; then
  curl -sL https://deb.nodesource.com/setup_10.x | bash -
fi
apt -y install nodejs
npm install --global yarn

echo "Complete Installation of Dependencies:"
apt update
apt -y install gcc g++ curl jq

echo "Defineing Environment Variables:"
export REPO_ROOT=${HOME}/go
export FLARENETWORK_ROOT=${REPO_ROOT}/src/gitlab.com/flarenetwork
export FLARE_ROOT=${FLARENETWORK_ROOT}/flare
export FLARE_REPO_URL=https://gitlab.com/flarenetwork/flare.git
export GOPATH=$(go env GOPATH)

echo "Creating Directories:"
mkdir -p ${FLARENETWORK_ROOT}
mkdir -p ${AVALANCHE_ROOT}

echo "Cloning Repo:"
cd ${FLARENETWORK_ROOT}
if [ ! -d ${FLARE_ROOT} ]; then
    git clone --no-checkout ${FLARE_REPO_URL}
else
    cd ${FLARE_ROOT}
    git pull ${FLARE_REPO_URL}
fi

echo "Checking Out Master:"
cd ${FLARE_ROOT}
git checkout master

# compile.sh options: local | songbird
bash compile.sh ${1} 
bash cmd/${1}.sh
