# Handle dependencies.
apt install git -y

# Create local directories.
mkdir ${HOME}/Repos/
cd ${HOME}/Repos

# Pull repo from gitlab.
git clone https://gitlab.com/flarenetwork/flare.git