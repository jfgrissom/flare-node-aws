# Handle dependencies.
apt install git -y

# Create local directories.
mkdir -p ${HOME}/Repos/
cd ${HOME}/Repos

# Pull repo from gitlab.
git clone --no-checkout https://gitlab.com/flarenetwork/flare.git

# At this point ${HOME}/Repos/flare exists.

# Install go environment.
snap install go