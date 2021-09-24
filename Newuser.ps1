# Import Active Directory module

Import-Module ActiveDirectory

 

# Create a new password

$securePassword = ConvertTo-SecureString “TESTpassw0rd!” -AsPlainText -Force

 

# Prompt user for CSV file path

$filepath = Read-Host -Prompt “Please enter the path to your CSV file”

 

# Import the file into a variable

$users = Import-Csv $filepath

 

# Loop through each row and gather information 

ForEach ($user in $users) {

 

        #Gather the user’s information 

$fname = $user.'First Name'

$lname = $user.'Last Name'

$jtitle = $user.'Job Title'

$officephon = $user.'Office Phone'

$emailaddress = $user.'Email Address'

$OUpath = $user.'organizational Unit'


 

# Create new AD user for each user in CSV file

New-ADUser -Name “$fname $lname” -UserPrincipalName “$fname.$lname” -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -EmailAddress $emailaddress

 

# echo output for each new user

echo “Account. Created for $fname $lname in $OUpath"

 

}
