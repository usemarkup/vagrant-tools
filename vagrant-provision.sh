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


if [ -f ./Vagrantfile ]; then
	echo "Halting vagrant"
	vagrant halt

	echo "Halted, reprovisioning"
	vagrant up --provision

	if [ $? -ne 0 ]; then
	    error "Provision failed on the VM"
	fi

	success "Provision passed, attempting restart"
	vagrant halt
	echo "Halted"
	vagrant up
	echo "Back up!"

	success "Vagrant running - DONE!"
else
	error "There is no Vagrantfile in this directory"
fi
