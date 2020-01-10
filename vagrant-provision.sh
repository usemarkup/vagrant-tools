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

echo "Bringing up vagrant."
cd ../
vagrant halt
vagrant up --provision

if [ $? -eq 1 ]; then
    error "Provision failed on the VM"
fi

success "Provision passed"
vagrant halt
vagrant up

success "Vagrant running - DONE!"