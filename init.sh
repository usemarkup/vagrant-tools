#!/bin/bash
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

#Take a message and exit code
function error
{
  echo "${RED}Error: ${1}${RESET}"
  if [ $# -gt 1 ]; then
    exit $2
  else
    exit 1
  fi
}

function success
{
  echo "${GREEN}${1}${RESET}"
}

echo ""
echo "~> Checking system for requirements"

echo "Checking for Ruby >= 2.3.0"
ruby -v | grep -v "2\.3\.[-9]+" > /dev/null
if [ $? -ne 0 ]; then
    error "Ruby >= 2.3.x is not installed!"
fi

echo "Checking for Bundler."
which bundler > /dev/null
if [ $? -ne 0 ]; then
    error "Bundler is not installed!"
fi

# short term removing this as it seems to cause more issues than its worth
#echo "Checking version of bundler."
#bundler -v | grep -v "2\.[0-9]+\.[0-9]+" > /dev/null
#if [ $? -ne 0 ]; then
#    error "Bundler 2.x is not installed, 'gem install bundler'"
#fi


echo "Checking for Virtualbox."
which VBoxManage > /dev/null
if [ $? -ne 0 ]; then
    error "Virtualbox is not installed!!"
fi

echo "Checking VirtualBox version."
vboxmanage --version | grep "^6" > /dev/null
if [ $? -ne 0 ]; then
    error "VirtualBox is installed but you need to be using a version in the 6.x range."
fi

echo "Checking for Vagrant."
which vagrant > /dev/null
if [ $? -eq 1 ]; then
    error "Vagrant is not installed! Please install it from https://www.vagrantup.com/"
fi

echo "Making sure vagrant has the vagrant-guest plugin"
vagrant plugin list | grep vagrant-vbguest > /dev/null
if [ $? -ne 0 ]; then
  echo "It didn't. Installing..."
    vagrant plugin install vagrant-vbguest
fi

success "System requirements satisfied"

if [ -d chef/ ]; then

  echo "Installing gems."
  cd chef/
  bundle check --path=vendor/bundle || bundle install --path=vendor/bundle --retry=3
  if [ $? -ne 0 ]; then
      error "Bundler was not able to install the gems correctly. Check STDOUT for more info."
  fi

  echo "Removing old cookbooks."
  rm -Rf cookbooks/

  echo "Vendoring cookbooks."
  bundle exec berks vendor cookbooks
  if [ $? -ne 0 ]; then
      error "Berkshelf was not able to install the cookbooks correctly."
  fi

  #Go back to root directory
  cd ../
  success "Cookbooks refreshed - DONE!"
else
  success "No chef directory found - DONE!"
fi
