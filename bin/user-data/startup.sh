# Handle dependencies.
apt install git -y

# Create a directory to hold repos.
export REPO_ROOT = ${HOME}/Repos
mkdir -p ${REPO_ROOT}
cd ${REPO_ROOT}

# Clone/Pull repo from gitlab.
export FLARE_ROOT = ${REPO_ROOT}/flare
export REPO_URL = https://gitlab.com/flarenetwork/flare.git
if [ ! -d ${FLARE_ROOT} ]; then
    git clone --no-checkout $URL ${FLARE_ROOT}
else
    cd ${FLARE_ROOT}
    git pull $URL
fi

# Install go environment.
snap install go