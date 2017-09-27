# VM-DeployVMDebian9 Create new VM Server(s) 
# Author: Matthieu Dechamps
# V1.1
# release date 2017-09-27
#
#
#version history
#v1 initial release on 2017-09-26
#v1.1 add hosts config script and move vm to vcenter folder


# Start configuration
# vCenter details
$vcenter = "vcenterIP"
$Vadmin = "VCenter Admin"
$Vpass = "VCenter Admin Password"
 
# Config VM peripherals
$vmname = "new vm name"
$ip = "new VM IP"
$netmask = "New VM SM"
$gateway = "New VM GW"
 
# VM user - must be root user
$GuestCred = "debian root user"
$GuestPass = "debian root user password+"
 
# VM Deployment Details
$destination_host = "Host IP (esxi)"
$template_name = "template name"

$datastore_name = "Data Store Name"

#Destination Folder
$Dest_Folder = "VCenter Destination Folder"

# End configuration
 
# PowerOn function, checks if VM is running and if needed start it
function PowerOn-VM {
    param ([string] $vm)
 
    if ($vm -eq "" ) {
        Write-Host "No VM defined."
    }
 
    if ((Get-VM $vm).powerstate -eq "PoweredOn" ) {
        Write-Host "$vm is already powered on."
        return "ok"
    } else {
        Start-VM -VM (Get-VM $vm) -Confirm:$false
        Write-Host "Starting $vm now."
        do {
            $status = (Get-vm $vm | Get-View).Guest.ToolsRunningStatus
            sleep 10
        } until ($status -eq "guestToolsRunning")
         
        return "ok"
    }
}
 
Connect-VIServer -Server $vcenter -User $Vadmin -Password $Vpass
 
New-VM -Name $vmname -Template $template_name -VMHost $destination_host -Datastore $datastore_name
 
$poweron = PowerOn-VM $vmname
 
if ($poweron -eq "ok") {
    Write-Host "$vmname started."
}
 
$command = "/root/customization.sh $vmname $ip $netmask $gateway"
#start script to configure network
Invoke-VMScript -VM $vmname -ScriptText $command -GuestUser $GuestCred -GuestPassword $GuestPass -ScriptType Bash


#Start script to change hostnamein hosts file
$command2 = "/root/host-config.sh $vmname"
Invoke-VMScript -VM $vmname -ScriptText $command2 -GuestUser $GuestCred -GuestPassword $GuestPass -ScriptType Bash
 
Restart-VMGuest -VM $vmname

#Move VM to appropriate VCenter folder
Move-VM -VM $vmname -Destination $Dest_Folder


Disconnect-VIServer -Server $vcenter -Confirm:$false