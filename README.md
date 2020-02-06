A simple bash script to check for generic system requirements and perform a bunch of standard tasks to bring up a vagrant box to serve our various virtual environemts. If ran outside of the environment, will simply check your system has the correct requirements.

The scripts can be run indpendently by modifying the following if you choose to:

```curl -s https://raw.githubusercontent.com/usemarkup/vagrant-tools/master/init.sh | bash```

However, note that the vagrant-provision script expects to be run within a directory with a Vagrantfile.
