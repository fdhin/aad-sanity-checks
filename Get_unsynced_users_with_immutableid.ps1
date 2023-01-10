Get-MsolUser -All | Where-Object {$_.BlockCredential -eq $false -and $_.ImmutableId -ne $null -and $_.Licenses.Count -eq 0 -and $_.LastDirSyncTime -eq $null} | Select-Object DisplayName, UserPrincipalName