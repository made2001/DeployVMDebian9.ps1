# DeployVMDebian9.ps1
POWERCLI Script to deploy, and configure Debian9 VM into VCenter 6.5 from a template via PowerShell.
Put the two sh files into /root of your debian template vm and make it executable (chmod +x customization.sh host-config.sh
)

Change the variables into PS1 file.
in host-config.sh change YOURDOMAINNAME by your domain name.

By default, in Debian 9, the network adapter is not named eth0 but ENS192 (in my case)
I have follow this tips to change his name http://www.itzgeek.com/how-tos/linux/debian/change-default-network-name-ens33-to-old-eth0-on-debian-9.html. If you don't wnat to change it, don't forget to change the adapter name into customization.sh


Script based on this tutorial, thank to his author
http://foonet.be/2012/02/10/bye-debianubuntu-guest-customozation-hello-powercli-and-bash/
