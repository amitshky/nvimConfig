-- map `space` key as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- options
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.showtabline = 2
vim.o.wrap = true
vim.o.linebreak = true
vim.o.scrolloff = 0
vim.o.clipboard = "unnamedplus"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250 -- decrease update time
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true
vim.o.list = true
vim.o.listchars = "tab:┊→,multispace:┊∙∙∙,space:∙"
vim.cmd([[autocmd BufEnter * set formatoptions-=r]]) -- disable auto comment in newline
vim.o.foldmethod ="manual"
vim.o.foldenable = false
-- vim.o.foldcolumn = "1"
vim.o.foldnestmax = 4
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.pumheight = 6 -- height menus such as autocompletion menu
vim.o.path = vim.o.path .. "**"
vim.o.signcolumn = "no" -- show/hide a column for error, warning signs; "no", "yes", "yes:<width>" eg: "yes:1"

-- colorscheme
vim.cmd.colorscheme("habamax")

-- tabline
vim.cmd("highlight TablineFill guibg=#282828")

-- statusline
vim.cmd("highlight StatusType guibg=#b16286 guifg=#282828")
vim.cmd("highlight StatusTypeSeparator guibg=#282828 guifg=#b16286")
vim.cmd("highlight StatusTypeSeparator2 guibg=#b18d62 guifg=#282828")
vim.cmd("highlight StatusFile guibg=#b18d62 guifg=#282828")
vim.cmd("highlight StatusFileSeparator guibg=#282828 guifg=#b18d62")
vim.cmd("highlight StatusModified guibg=#282828 guifg=#d3869b")
vim.cmd("highlight StatusBuffer guibg=#62b18d guifg=#282828")
vim.cmd("highlight StatusBufferSeparator guibg=#282828 guifg=#62b18d")
vim.cmd("highlight StatusLocation guibg=#6286b1 guifg=#282828")
vim.cmd("highlight StatusLocationSeparator guibg=#282828 guifg=#6286b1")
vim.cmd("highlight StatusLocationSeparator2 guibg=#62b18d guifg=#282828")
vim.cmd("highlight StatusPercent guibg=#282828 guifg=#ebdbb2")
vim.cmd("highlight StatusPercentSeparator guibg=#6286b1 guifg=#282828")
vim.cmd("highlight StatusNorm guibg=#282828 guifg=white")
vim.o.statusline = "%#StatusType#"
                .. " "
                .. "%Y"
                .. " "
                .. "%#StatusTypeSeparator#"
                .. ""
                .. "%#StatusTypeSeparator2#"
                .. ""
                .. "%#StatusFile#"
                .. " "
                .. "%F"
                .. " "
                .. "%#StatusFileSeparator#"
                .. ""
                .. ""
                .. "%#StatusModified#"
                .. " "
                .. "%m"
                .. " "
                .. "%#StatusNorm#"
                .. " "
                .. "%="
                .. " "
                .. "%#StatusBufferSeparator#"
                .. ""
                .. ""
                .. "%#StatusBuffer#"
                .. " "
                .. " "
                .. "%n"
                .. " "
                .. "%#StatusLocationSeparator2#"
                .. ""
                .. "%#StatusLocationSeparator#"
                .. ""
                .. "%#StatusLocation#"
                .. " "
                .. "今 "
                .. "%3l:%c"
                .. " "
                .. "%#StatusPercentSeparator#"
                .. ""
                .. "%#StatusPercent#"
                .. " "
                .. "%3p%%"
                .. " "

-- keymaps
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>' )
vim.keymap.set({ 'i', 'c' }, 'jk', '<esc>')
vim.keymap.set('n', 'J', '<nop>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = "Quit" })
vim.keymap.set('n', '<leader>Q', '<cmd>qa<cr>', { desc = "Quit all" })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = "Save" })
vim.keymap.set('n', '<leader>W', '<cmd>wa<cr>', { desc = "Save all" })
vim.keymap.set('i', '<C-h>', '<C-w>')
vim.keymap.set({ 'n', 'v' }, 'U', '<C-r>')
vim.keymap.set({ 'n', 'v' }, '<C-r>', '<U>')

-- terminal mode
vim.keymap.set('t', 'jk', '<C-\\><C-n>') -- switch to normal mode 
vim.keymap.set('t', '<esc>', '<C-\\><C-n><cmd>q<cr>', { desc = "Close terminal" })
vim.keymap.set('t', '<C-e>', '<esc>') -- <esc> useful in lazygit
-- navigation in terminal mode
vim.keymap.set('t', '<C-j>', '<down>')
vim.keymap.set('t', '<C-k>', '<up>')
vim.keymap.set('t', '<C-l>', '<right>')
vim.keymap.set('t', '<C-h>', '<left>')

-- prevents the delete operation to pollute the unnamed buffer
vim.keymap.set('n', 'dd', '"add')
vim.keymap.set({ 'n', 'v', 'x' }, 'd', '"_d')

-- for word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- move line/s
vim.keymap.set('i', '<A-j>', '<esc>:m .+1<cr>==gi')
vim.keymap.set('i', '<A-k>', '<esc>:m .-2<cr>==gi')
vim.keymap.set('n', '<A-j>', '<esc>:m .+1<cr>==')
vim.keymap.set('n', '<A-k>', '<esc>:m .-2<cr>==')
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv-gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv-gv")

-- indentation
-- vim.keymap.set('n', '>', '>>')
-- vim.keymap.set('n', '<', '<<')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- buffers
vim.keymap.set('n', '<S-h>', '<cmd>bp<cr>') -- prev buffer
vim.keymap.set('n', '<S-l>', '<cmd>bn<cr>') -- next buffer

-- tabs
vim.keymap.set('n', '<M-h>', '<cmd>tabprevious<cr>')
vim.keymap.set('n', '<M-l>', '<cmd>tabNext<cr>')

-- leader key keymaps
vim.keymap.set('n', '<leader>h', '<cmd>nohl<cr>', { desc = "Remove search highlights" }) -- remove search highlights
-- split window
vim.keymap.set('n', '<leader>\\\\', '<C-w>v', { desc = "Vertically" }) -- split vertically
vim.keymap.set('n', '<leader>\\|', '<C-w>s', { desc = "Horizontally" }) -- split horizontally
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
-- resize window
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>')
