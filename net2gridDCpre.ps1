# Script Name                           net2gridDCpre.ps1
# Authors                               Kwesi Keller, Marcus Miles, Bill Kachersky
# Date of last revision                 09/22/2021
# Description of purpose                

# Variables

$MaskBits = 24
$Gateway = "192.168.10.1"
$IPType = "IPv4"


# Functions


function compname {
    $Newname=Read-Host -Prompt "Please specify the new hostname for the machine"    
    Write-Host "Be aware that the computer will automatically reboot for the name change to take effect. You will need to log back in and switch to the second script."
    Rename-Computer -NewName $Newname
    Start-Sleep -Seconds 1
    
}




# Main
 # Set Static IP Address

 Write-Host {"Welcome! You've fired up the Domain Controller Creation Automation Script, let's get a few prerequisite items sorted."}
        $DC_IP=Read-Host -Prompt "Please specify an IP address to statically assign to this machine"
        Start-Sleep -Seconds 1
        Write-Host "Working!"
# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $DC_IP `
 -PrefixLength $MaskBits `
 -DefaultGateway $Gateway
    
        # Rename Windows Server
        Write-Host "Okay, next item; let's choose a new name for this machine"

        compname

        Write-Host "We'll need to restart before proceeding. Save anything you need to before proceeding."
        Start-Sleep -Seconds 1
        $Restart=Read-Host -Prompt "Ready? [Y] or [N]"
        if ($Restart -eq "y"){
           Write-Host "Shutting down now."
           Restart-Computer -Force
        }
        else {
              Exit
        }





# End
