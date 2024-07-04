vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- automatically check for plugin updates
  checker = { enabled = true },

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NvimTree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = false,
              modified = false,
            },
          }
        },
        git = {
          enable = false,
        },
      })
    end,
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      require("telescope").setup()
    end,
    dependencies = { "telescope-fzf-native.nvim" },
    lazy = true,
    cmd = "Telescope",
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },

  -- which key
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()
    end,
  },

  -- cmp
    {
    "hrsh7th/nvim-cmp",
    config = function()
      require("cmp").setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
      })
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "cmp-nvim-lsp",
      "cmp_luasnip",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
  },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "hrsh7th/cmp-cmdline", lazy = true },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup()
    end,
  },

  -- lines in indentations
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- bufferline
  {
    'akinsho/bufferline.nvim', 
    config = function()
      require("bufferline").setup({
        options = {
          separator_style = "slant", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          show_close_icon = false,
          show_buffer_close_icons = false,
        },
      })
    end,
    version = "*",
    event = "BufReadPre",
  },

  -- lualine
  {
    -- "hoob3rt/lualine.nvim",
    "nvim-lualine/lualine.nvim",
    -- "Lunarvim/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = 'jellybeans',
        },
        sections = {
          lualine_b = { 'branch' },
        },
      })
    end,
    event = "VimEnter",
  },
})


-- options
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
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
vim.o.listchars = "tab:→→,space:∙"
vim.cmd([[autocmd BufEnter * set formatoptions-=r]]) -- disable auto comment in newline
vim.o.foldmethod="indent"
vim.o.foldenable=false
vim.o.foldnestmax=1
vim.o.splitbelow=true
vim.o.splitright=true

-- colorscheme
vim.cmd.colorscheme("habamax")


-- keymaps
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>' )
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', '<C-h>', '<C-w>')
vim.keymap.set({ 'n', 'v' }, 'U', '<C-r>')
vim.keymap.set({ 'n', 'v' }, '<C-r>', '<U>')

-- terminal mode
vim.keymap.set('t', 'jk', '<C-\\><C-n>') -- switch to normal mode 
-- navigation in terminal mode
vim.keymap.set('t', '<C-j>', '<up>')
vim.keymap.set('t', '<C-k>', '<down>')
vim.keymap.set('t', '<C-l>', '<nop>')
vim.keymap.set('t', '<C-h>', '<nop>')

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
vim.keymap.set('n', '>', '>>')
vim.keymap.set('n', '<', '<<')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- buffers
vim.keymap.set('n', '<S-h>', ':bp<cr>') -- prev buffer
vim.keymap.set('n', '<S-l>', ':bn<cr>') -- next buffer

-- tabs
vim.keymap.set('n', '<M-h>', ':tabprevious<cr>')
vim.keymap.set('n', '<M-l>', ':tabNext<cr>')

-- leader key keymaps
-- which key register
-- Document existing key chains
require('which-key').register {
  ['<leader>f'] = { name = 'Telescope', _ = 'which_key_ignore' },
  ['<leader>\\'] = { name = 'Split window', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = 'Toggle term', _ = 'which_key_ignore' },
}
-- visual mode
require('which-key').register({
  -- ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

vim.keymap.set('n', '<leader>h', ':nohl<cr>', { desc = "Remove search highlights" }) -- remove search highlights
-- comment
-- vim.keymap.set('n', '<leader>/', '<Plug>(comment_toggle_linewise_current)') -- comment line
-- vim.keymap.set('v', '<leader>/', '<Plug>(comment_toggle_linewise_visual)') -- comment line in visual mode
-- split window
vim.keymap.set('n', '<leader>\\\\', '<C-w>v', { desc = "Vertically" }) -- split vertically
vim.keymap.set('n', '<leader>\\|', '<C-w>s', { desc = "Horizontally" }) -- split horizontally
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
-- resize window
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
-- NvimTree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', { desc = "Toggle NvimTree" })
-- telescope
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close, -- Esc to close telescope in insert mode
      },
    }
  }
})
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = "Grep string under the cursor or selection" })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').current_buffer_fuzzy_find, { desc = "Fuzzy find in current buffer" })
vim.keymap.set('n', '<leader>fG', require('telescope.builtin').git_files, { desc = "Git files" })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = "Help tags" })
-- toggleterm
vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=tab<cr>')
vim.keymap.set('n', '<leader>tj', ':ToggleTerm direction=horizontal<cr>')
vim.keymap.set('n', '<leader>tl', ':ToggleTerm direction=vertical<cr>')
vim.keymap.set('n', '<leader>tk', ':ToggleTerm direction=float<cr>')
