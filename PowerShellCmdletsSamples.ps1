# ** Pre-requisite: Latest PowerShell Core (Not a hard rule though :) ) **

# Installing the Graph PowerShell module v0.1.1 (with no previous versions installed)
Install-module Microsoft.Graph

# Get Commands Available for Users
Get-Command -Module Microsoft.Graph* *Users*

# Connect using previously consented permissions
Connect-Graph

# Try to Get-User
Get-MgUser

# Grant more permissions
Connect-Graph -Scopes "User.Read","User.ReadWrite.All","Mail.ReadWrite",`
            "Directory.ReadWrite.All","Chat.ReadWrite", "People.Read", `
            "Group.Read.All", "Directory.AccessAsUser.All", "Tasks.ReadWrite", `
            "Sites.Manage.All"

# Now Get-MgUser works

# List of Users In Tenant
Get-MgUser -top 999 | Select-Object id, displayName, OfficeLocation, BusinessPhones

# List of Users with no Office Location
Get-MgUser | Select-Object id, displayName, OfficeLocation, BusinessPhones | Where-Object {!$_.OfficeLocation }

# Update the office location of the User
Update-MgUser -UserId $UserId -OfficeLocation "The Oval"

# Get all Groups
Get-MgGroup -top 999 | Select-Object id, DisplayName, GroupTypes

# Get-Details of a single Group
Get-MgGroup -GroupId $groupId | Format-List | more

# New Group
$group = new-MgGroup -DisplayName "Interns" -MailEnabled:$false -mailNickName "interns" -SecurityEnabled

# Create a new User
new-MgUser -displayName "Robert Greene" -AccountEnabled -PasswordProfilePassword "microsoft@2020" `
         -MailNickname "Robert.Greene" -UserPrincipalName "Robert.Greene@graphgeek.onmicrosoft.com"

# Add member to Group (this would fail)
new-MgGroupMember -GroupId $group.Id -DirectoryObjectId $UserId

# To add a new member to a group (old and dirty way; v0.2.0 will have the new command)
# Register our old repo with this.

Register-PSRepository `
-Name GraphPowerShell `
-SourceLocation https://graphpowershellrepository.azurewebsites.net/nuget

# Install Microsoft.Graph.Beta.Groups.DirectoryObjects by running...
Install-module Microsoft.Graph.Beta.Groups.DirectoryObject -Repository GraphPowerShell

# Run New-GroupMember minus the Mg prefix, i.e. new-GroupMember -GroupId $group.Id -DirectoryObjectId $UserId

# View new member to recently added Group
Get-MgGroupMember -GroupId $group.Id  | ForEach-Object { @{ UserId=$_.Id}} | Get-MgUser | Select-Object id, DisplayName, Mail

# Remove Group
Remove-MgGroup -GroupId $group.Id

# Disconnect Graph
Disconnect-Graph
