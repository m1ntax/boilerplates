# pairs of hosts and ssh usernames
$hosts = @{
    "vps.vhosted.xyz"= "jam"
    "ha.vhosted.xyz" = "j4k"
    "dh.vhosted.xyz" = "j4k"
    "pi.vhosted.xyz" = "j4k"
    "uc.vhosted.xyz" = "j4k"
}
$configPath = "$env:USERPROFILE\.ssh"
$configFile = "$configPath\config"

# generate key on Windows 10/11
$key = "$configPath\$($env:COMPUTERNAME)_key" # key file path
if (!(Test-Path $key)) {
    ssh-keygen.exe -t ed25519 -C $env:COMPUTERNAME -f $key
}
else {
    Write-Host "SSH key already exists: $key. No new key has been created!" -ForegroundColor Green
}

# check for config file. create one if nonexistent
if (!(Test-Path $configFile)) {
    Write-Host "No config file found. Creating $configFile..."
    New-Item -ItemType File -Path $configFile
}

# get config file content
$configFileContent = Get-Content $configFile

# check for existing host configs on configfile. add host config if nonexistent
foreach ($hostname in $hosts.GetEnumerator()) {
    $currentHost = $hostname.Name
    $currentUsername = $hostname.Value
    $target = "$currentUsername@$currentHost" # target host to copy the public key to

    if ($configFileContent | Select-String "Host $currentHost") {
        Write-Host "Found existing config for $currentHost. No adjustments made."
        Write-Host "Assuming the key has been copied to the $currentHost already. If not, run the following command:" -ForegroundColor Yellow
        Write-Host "Get-Content `"$key.pub`" | ssh $target `"cat >> .ssh/authorized_keys`"" -ForegroundColor Yellow
    }
    else {
        Write-Host "Appending config for host $currentHost"
        $append = "`nHost $currentHost`n  HostName $currentHost`n  Port 22`n  User $currentUsername`n  IdentityFile $key`n  IdentitiesOnly yes"
        Add-Content -Path $configFile -Value $append

        # copy public key to target linux host
        Write-Host "Connecting and copying the public key to $currentHost..."
        Get-Content "$key.pub" | ssh $target "cat >> .ssh/authorized_keys" 
    }
}
