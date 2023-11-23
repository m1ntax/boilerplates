# CustomTerminal

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

## Download customized theme

## Edit PS Profile
```
code $PROFILE
```
```
function Start-GodMode {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\custom_illusi0n.omp.omp.json" | Invoke-Expression
}
```
