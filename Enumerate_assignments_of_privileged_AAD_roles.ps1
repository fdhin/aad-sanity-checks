# Get all privileged roles
$roles = Get-AzureADDirectoryRole

# Create an empty array to store the role information
$outputArray = @()

# Loop through each role and get its members
foreach ($role in $roles) {
    $roleName = $role.DisplayName
    $roleMembers = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId
    $roleMembers = $roleMembers | Select-Object -ExpandProperty DisplayName
    if ($roleMembers) {
        # Create an object to store the role name
        $roleInfo = [pscustomobject]@{
            RoleName = $roleName
        }
        # Loop through each member and create an object for each one
        foreach ($member in $roleMembers) {
            # Add the member to the object
            $memberInfo = [pscustomobject]@{
                RoleName = $roleInfo.RoleName
                RoleMember = $member
            }
            # Add the object to the output array
            $outputArray += $memberInfo
        }
    }
}

# Export the output array to a CSV file
$outputArray | Export-Csv -Path "members.csv" -NoTypeInformation