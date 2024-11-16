# CustomTerminal

## Install/Update PSReadLine
```
Install-Module PSReadLine -Force
```

## Install Nerd Font
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/CascadiaCode.zip

## Configure Terminal Profile to use Nerd Font
Ctrl+, -> Choose Profile -> Appearance -> Font Face

## Install Oh My Posh
```
winget install JanDeDobbeleer.OhMyPosh
```
```
winget upgrade oh-my-posh
```
Use the following command to use the windows store version (automatically updated)
```
winget install XP8K0HKJFRXGCK
```

## Download customized theme
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/m1ntax/boilerplates/refs/heads/main/WindowsTerminal/custom_illusi0n.omp.json -Outfile $env:POSH_THEMES_PATH\custom_illusi0n.omp.json
```

## Edit PS Profile, add to the bottom
```
code $PROFILE
```
```
# apply custom theme if ps has been started in Windows Terminal
if ($env:WT_SESSION) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\custom_illusi0n.omp.json" | Invoke-Expression
}
```
