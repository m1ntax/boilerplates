function which ($command) { 
    Get-Command -Name $command -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue 
} 

function Convert-Base64 {
    Param (
        [Parameter(Mandatory = $true,
            HelpMessage = "Enter the string you want to encode to or decode from Base64",
            Position = 0,
            ValueFromPipeline = $true)]
        [string]$Text,

        [Parameter(Mandatory = $true,
            ParameterSetName = "Encode")]
        [switch]$EncodeToBase64,

        [Parameter(Mandatory = $true,
            ParameterSetName = "Decode")]
        [switch]$DecodeFromBase64
    )

    if ($EncodeToBase64) {
        return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Text))
    }
    elseif ($DecodeFromBase64) {
        return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Text))
    }
}

function Convert-Base64url {
    Param (
        [Parameter(Mandatory = $true,
            HelpMessage = "Enter the string you want to encode to or decode from Base64url",
            Position = 0,
            ValueFromPipeline = $true)]
        [string]$Text,

        [Parameter(Mandatory = $true,
            ParameterSetName = "Encode")]
        [switch]$EncodeToBase64url,

        [Parameter(Mandatory = $true,
            ParameterSetName = "Decode")]
        [switch]$DecodeFromBase64url
    )

    if ($EncodeToBase64url) {
        $Encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Text))
        $Encoded = $Encoded.Split("=")[0].Replace("+", "-").Replace("/", "_")
        return $Encoded
    }
    elseif ($DecodeFromBase64url) {
        $Decoded = $Text.Replace("-", "+").Replace("_", "/")

        switch ($Decoded.Length % 4) {
            0 { break }
            2 { $Decoded += '=='; break }
            3 { $Decoded += '='; break }
        }
        return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Decoded))
    }
}

Function Get-CustomFunctions {
    Get-Content -Path $env:OneDrive\PowerShell\Microsoft.PowerShell_profile.ps1 | Select-String -Pattern "^function.+" | ForEach-Object {
        # Find function names that contains letters, numbers and dashes
        [Regex]::Matches($_, "^function ([a-z0-9.-]+)", "IgnoreCase").Groups[1].Value
    } | Where-Object { $_ -ine "prompt" } | Sort-Object
}

# PATH
$env:PATH = "$env:PATH;$env:OneDrive\Tools"
$env:PATH = "$env:PATH;$env:OneDrive\Tools\SysinternalsSuite"

$env:Git = "C:\work\Git"

# Alias definition
Set-Alias tf -Value terraform.exe
Set-Alias grep findstr

# testing some stuff
# ----------------------------------
Import-Module -Name Terminal-Icons
Import-Module -Name z

Set-PSReadLineOption -PredictionSource History 
Set-PSReadLineOption -PredictionViewStyle ListView 
Set-PSReadLineOption -EditMode Windows

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
# ----------------------------------

# Welcome MsgProfile
$MsgProfile = "* PS Profile: $PROFILE *"
$MsgVersion = ("* PS Version: $($PSVersionTable.PSVersion.ToString())")
Write-Host ("*" * $MsgProfile.Length)
Write-Host $MsgProfile
Write-Host ($MsgVersion + (" " * ($MsgProfile.Length - $MsgVersion.Length - 1) + "*"))
Write-Host ("*" * $MsgProfile.Length)
Write-Host "The following custom functions are available:`n"
Get-CustomFunctions
Write-Host "`nNow go my son, do your work!"

# apply custom theme if ps has been started in Windows Terminal
if ($env:WT_SESSION) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\custom_illusi0n.omp.json" | Invoke-Expression
}