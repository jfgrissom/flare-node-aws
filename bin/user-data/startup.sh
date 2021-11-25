#!/bin/sh
# This scripts accepts 1 argument (local | songbird).

echo "Installing Dependencies:"
apt -y install git curl

echo "Installing Go:"
go version | grep 1.15
if [ ${?} -eq 1 ]; then
    apt remove go
    apt remove golang-go
    snap remove go
fi
snap install go --channel=1.15/stable --classic

echo "Installing NodeJS:"
node --version | grep v10
if [ ${?} -eq 1 ]; then
    apt remove nodejs
fi
sudo snap install node --channel=10/stable --classic

echo "Installing Yarn:"
npm install --global yarn

echo "Updateing System:"
apt update

echo "Completing Installation of Dependencies:"
apt -y install gcc g++ curl jq

echo "Defineing Environment Variables:"
export REPO_ROOT=${HOME}/go
export FLARENETWORK_ROOT=${REPO_ROOT}/src/gitlab.com/flarenetwork
export FLARE_ROOT=${FLARENETWORK_ROOT}/flare
export FLARE_REPO_URL=https://gitlab.com/flarenetwork/flare.git
export GOPATH=$(go env GOPATH)

echo "Adding GOPATH to Root Profile:"
export PROFILE=${HOME}/.profile
grep "GOPATH" ${HOME}/.profile
if [ $? -eq 1 ]; then echo "export GOPATH=${GOPATH}" >> ${PROFILE}; echo "" >> ${PROFILE}; fi

echo "Creating Directories:"
mkdir -p ${FLARENETWORK_ROOT}

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
