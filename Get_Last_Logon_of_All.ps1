# Connect to Azure AD
# Connect-AzureAD

# Get all users in Azure AD
$users = Get-AzureADUser

# Iterate through each user and get their last logon date and time
foreach ($user in $users) {
    $userPrincipalName = $user.UserPrincipalName
    $lastLogonDateTime = (Get-AzureADUser -ObjectId $user.ObjectId).LastLogonDateTime

    # Display the user principal name and last logon date and time
    Write-Output "User Principal Name: $userPrincipalName"
    Write-Output "Last Logon Date and Time: $lastLogonDateTime"
    Write-Output ""
}