$DOTFILES = Split-Path $MyInvocation.MyCommand.Path -Parent

# Zsh equivalent (PowerShell profile)
$PROFILE_PATH = $PROFILE.CurrentUserAllHosts
$CUSTOM_PROFILE = Join-Path $HOME "PowerShell_Local.ps1"

New-Item -ItemType SymbolicLink -Path $CUSTOM_PROFILE -Target (Join-Path $DOTFILES "powershell\PowerShell_Local.ps1") -Force

if (!(Select-String -Path $PROFILE_PATH -Pattern ". $CUSTOM_PROFILE" -SimpleMatch -Quiet)) {
    Add-Content -Path $PROFILE_PATH -Value ". $CUSTOM_PROFILE"
}

# Git
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME ".gitconfig") -Target (Join-Path $DOTFILES "git\.gitconfig") -Force

# vim
Remove-Item -Path (Join-Path $HOME "_vimrc") -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path (Join-Path $HOME "_vimrc") -Target (Join-Path $DOTFILES "vim\.vimrc") -Force
