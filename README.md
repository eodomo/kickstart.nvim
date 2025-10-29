Windows Install Instructions
## Install nvim
Installed nvim with winget install Neovim.Neovim

Cleared existing nvim config from `$env:\USERPROFILE\AppData\Local\nvim\`

## kickstart.nvim config
### Fork kickstart.nvim (if starting from scratch)
Forked kickstart.nvim to [eodomo/kickstart.nvim: A launch point for your personal nvim configuration (github.com)](https://github.com/eodomo/kickstart.nvim?tab=readme-ov-file)
### Clone existing kickstart.nvim config
If you already have a working config, just clone that to `$env:\USERPROFILE\AppData\Local\nvim\`

## Install ripgrep
Install ripgrep with `winget install BurntSushi.ripgrep.MSVC`
## Install gcc + make
Install MSYS2

In MSYS2, ran `pacman -S mingw-w64-ucrt-x86_64-gcc` to install gcc

Run `pacman -Syu`

Add `C:\msys64\ucrt64\bin` to PATH user environment variable

Run `pacman -S make` to install make

Add `C:\msys64\usr\bin` to PATH as well for make

Run `pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain`

	TODO: Test running this command only- the others might not be needed
  
Run `pacman -S unzip` to install unzip

## Launch nvim
Open a new pwsh window (need the new PATH) and launch nvim

Check install progress with `:Lazy`

Run updates with U

Modify config in `$env:\USERPROFILE\AppData\Local\nvim\` as needed

## GDscript
See [here](https://www.reddit.com/r/neovim/comments/1c2bhcs/godotgdscript_in_neovim_with_lsp_and_debugging_in/)for info about setting up gdscript

For a quick setup, and assuming LSP + DAP are already set up correctly in nvim config:

In Godot. go to Editor Settings > Text Editor > External
  
Set "Exec Path" to nvim binary. By default that's `C:/Program Files/Neovim/bin/nvim.exe`
  
Set "Exec Flags" to `--server 127.0.0.1:6004 --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"`
  
Launch Neovim with `nvim --listen 127.0.0.1:6004`

# Blink Requirements
nvim v0.11+

	winget install Neovim.Neovim
  
fzf - https://github.com/junegunn/fzf?tab=readme-ov-file#windows-packages

	winget install fzf
  
rust toolchain - https://rustup.rs/
