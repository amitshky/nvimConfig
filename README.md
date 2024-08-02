# nvimConfig
Neovim config file

NOTE: the `kickstart.lua` file is from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua).

## Configuring multiple nvim instances
- if your `.config` directory looks like this:
```
.config/
├── nvim/
│   ├── init.lua
├── nvim-minimal/
│   └── init.lua
```
- then you can open `nvim` with nvim-minimal config like this:
```
NVIM_APPNAME=nvim-minimal nvim
// OR
nvim --clean -u ~/.config/nvim-minimal/init.lua
```
