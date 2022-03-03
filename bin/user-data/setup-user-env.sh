echo "- Defining Environment Variables:"
export REPO_ROOT=${HOME}/go
export FLARENETWORK_ROOT=${REPO_ROOT}/src/gitlab.com/flarenetwork
export FLARE_ROOT=${FLARENETWORK_ROOT}/flare
export FLARE_REPO_URL=https://github.com/flare-foundation/flare.git
export GOPATH=$(go env GOPATH)

echo "- Adding GOPATH to Root Profile:"
export PROFILE=${HOME}/.profile
grep "GOPATH" ${HOME}/.profile
if [ $? -eq 1 ]; then echo "export GOPATH=${GOPATH}" >> ${PROFILE}; echo "" >> ${PROFILE}; fi

echo "- Creating Directories:"
mkdir -p ${FLARENETWORK_ROOT}

echo "- Cloning Repo:"
cd ${FLARENETWORK_ROOT}
if [ ! -d ${FLARE_ROOT} ]; then
    git clone --no-checkout ${FLARE_REPO_URL}
else
    cd ${FLARE_ROOT}
    git pull ${FLARE_REPO_URL}
fi

echo "- Compiling Songbird:"
cd ${FLARE_ROOT}
git checkout master

./compile.sh songbird
