RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

echo ""
echo "~> Checking system for requirements"

if ! [ -x "$(command -v bundler)" ]; then
  echo "${RED}bundler is not installed, please run \"gem install bundler\"${RESET}"
  exit 1
fi

if ! [ -x "$(command -v vagrant)" ]; then
  echo "${RED}vagrant is not installed, please download from https://www.vagrantup.com/${RESET}"
  exit 1
fi

if ! [ -x "$(command -v executable-hooks-uninstaller)" ]; then
  echo "${RED}executable-hook is not installed, run \"sudo gem install executable-hook\"${RESET}"
  exit 1
fi

cd chef/

echo "~> Installing gems from gemfile.lock"


bundle install
rm -Rf cookbooks/
berks vendor cookbooks
cd ../

echo "~> vagrant: $(vagrant --version)"
echo "~> berks: $(berks --version)"
echo "~> ruby: $(ruby --version)"

vagrant halt
vagrant up --provision
echo "FINISHED - REBOOTING VM"
vagrant halt
vagrant up
