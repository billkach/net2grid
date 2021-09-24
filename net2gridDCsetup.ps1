# Script Name                           net2gridDCpre.ps1
# Authors                               Kwesi Keller, Marcus Miles, Bill Kachersky
# Date of last revision                 09/22/2021
# Description of purpose                

# Variables

# Functions

function PrimaryDCStandUp {
    
        Write-Host "Next, we'll install AD-DS Services"
        Write-Host "Working.."
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
        Write-Host "Complete!"
        Write-Host "Next, it's time to create the ADDS forest this DC will preside over, `
                    you'll see some information and credential prompts in a moment"
                    Install-ADDSForest `
                    -CreateDnsDelegation:$false `
                    -DatabasePath "C:\Windows\NTDS" `
                    -DomainMode "WinThreshold" `
                    -DomainName "net2grid.globexpower.com" `
                    -DomainNetbiosName "NET2GRID1" `
                    -ForestMode "WinThreshold" `
                    -LogPath "C:\Windows\NTDS" `
                    -NoRebootOnCompletion:$false `
                    -SysvolPath "C:\Windows\SYSVOL" `
                    -Force:$true
}

function SecondaryDCStandUp {
        Write-Host "Next, we'll install AD-DS Services"
        Write-Host "Working.."
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
        Write-Host "Complete!"
        Write-Host "Next, we'll add this DC to the existing domain, net2grid.globexpower.com ;  `
                    you'll see some information and credential prompts in a moment"
        Install-ADDSDomainController -DomainName net2grid.globexpower.com -InstallDNS
}

# Main

Write-Host "Welcome back! Here's the changes we've made so far:"
Write-Host "New Computer Name:" $env:COMPUTERNAME
Start-Sleep -Seconds 3
ipconfig

Start-Sleep -Seconds 1

Write-Host {"Now that we've gotten that out of the way.. What sort of DC would you like to create?"}
$DCvar=Read-Host {"Primary or Secondary: "} 

if ($DCvar -eq "primary"){
    Write-Host "Today is a special day! Let's create a brand new domain."
        Start-Sleep -Seconds 1
    PrimaryDCStandUp
}
elseif ($DCvar -eq "secondary")
{
    Write-Host "Alright, secondary it is."
        Start-Sleep -Seconds 1
    SecondaryDCStandUp
}
else
{
    Write-Host "Not sure what you meant by that, try running the script again."
 }  




# Add DNS
Install-WindowsFeature -Name DNS -IncludeManagementTools