# Connect to Microsoft Online Services (Azure Active Directory)
Connect-MsolService

# Initialize an empty array to store results
$results = @()

# Get a list of all users in the directory
$users = Get-MsolUser -All

# Loop through each user in the list
foreach ($user in $users) {
    # Get strong authentication requirements, phone app details, and methods
    $mfaStatus = $user.StrongAuthenticationRequirements.State
    $phoneApp = $user.StrongAuthenticationPhoneAppDetails
    $methodTypes = $user.StrongAuthenticationMethods

    # If MFA is enabled or there are authentication methods, set variables based on user details
    if ($mfaStatus -ne $null -or $methodTypes -ne $null) {
        if ($null -eq $mfaStatus) {
            $mfaStatus = "Enabled (Conditional Access)"
        }
        $authMethods = $methodTypes.MethodType
        $defaultAuthMethod = ($methodTypes | Where-Object {$_.IsDefault -eq "True"}).MethodType
        $verifyEmail = $user.StrongAuthenticationUserDetails.Email
        $phoneNumber = $user.StrongAuthenticationUserDetails.PhoneNumber
        $alternativePhoneNumber = $user.StrongAuthenticationUserDetails.AlternativePhoneNumber
    }
    # If MFA is disabled, set variables to null
    else {
        $mfaStatus = "Disabled"
        $defaultAuthMethod = $null
        $verifyEmail = $null
        $phoneNumber = $null
        $alternativePhoneNumber = $null
    }

    # Add a new object to the results array with user details
    $results += New-Object PSObject -Property @{
        UserName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        MFAStatus = $mfaStatus
        AuthenticationMethods = $authMethods
        DefaultAuthMethod = $defaultAuthMethod
        MFAEmail = $verifyEmail
        PhoneNumber = $phoneNumber
        AlternativePhoneNumber = $alternativePhoneNumber
        DeviceName = $phoneApp.DeviceName
    }
}

# Select certain properties from the results array and export them to a CSV file
$results | Select-Object UserName,UserPrincipalName,MFAStatus,DefaultAuthMethod,MFAEmail,PhoneNumber,AlternativePhoneNumber,DeviceName | Export-Csv MFAReport.csv