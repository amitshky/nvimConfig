-- map `space` key as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- disable netrw for NvimTree
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

  -- colorschemes
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts ={} },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- NvimTree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = false,
              modified = false,
            },
          }
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      require("telescope").setup({})
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
    version = "2.1.0",
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
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
    event = "BufReadPre",
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = 'gruvbox',
        },
        sections = {
          lualine_b = { 'branch' },
        },
      })
    end,
    event = "VimEnter",
  },

  -- lazygit
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- cmp (auto completion)
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        -- snippet = {
        --   -- REQUIRED - you must specify a snippet engine
        --   expand = function(args)
        --     require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        --   end,
        -- },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<tab>'] = cmp.mapping.select_next_item(),
          ['<S-tab>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          -- { name = 'luasnip' }, -- For luasnip users.
          { name = 'path' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },

  -- lsp configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- configures lua lsp for nvim
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear=true }),
        callback = function(event)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Go to definition" })
          vim.keymap.set('n', 'gd', require("telescope.builtin").lsp_definitions, { desc = "Go to definition" })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references, { desc = "Go to references" })
          vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Open diagnostics popup" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostics" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostics" })
        end,
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd" },
      })
      -- Set up lspconfig.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
    end,
  },
})


-- options
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
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
vim.o.foldmethod ="manual"
vim.o.foldenable = false
vim.o.foldcolumn = "1"
vim.o.foldnestmax = 4
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.signcolumn = "yes:1"
vim.o.pumheight = 6 -- height menus such as autocompletion menu

-- colorscheme
vim.cmd.colorscheme("gruvbox")


-- keymaps
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>' )
vim.keymap.set('i', 'jk', '<esc>')
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
-- which key register
-- Document existing key chains
require('which-key').register {
  ['<leader>f'] = { name = 'Telescope', _ = 'which_key_ignore' },
  ['<leader>\\'] = { name = 'Split window', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = 'Toggle term', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = 'Session', _ = 'which_key_ignore' },
}
-- visual mode
require('which-key').register({
  -- ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

vim.keymap.set('n', '<leader>h', '<cmd>nohl<cr>', { desc = "Remove search highlights" }) -- remove search highlights
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
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>')
-- NvimTree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = "Toggle NvimTree" })
-- telescope
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close, -- Esc to close telescope in insert mode
        ["<C-h>"] = function() vim.api.nvim_input("<C-w>") end, -- Ctrl + Backspace
      },
    }
  }
})
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files({ hidden = true }) end, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').grep_string, { desc = "Grep string under the cursor or selection" })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').current_buffer_fuzzy_find, { desc = "Fuzzy find in current buffer" })
vim.keymap.set('n', '<leader>fG', require('telescope.builtin').git_files, { desc = "Git files" })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = "Help tags" })
-- toggleterm
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm direction=tab<cr>')
vim.keymap.set('n', '<leader>tj', '<cmd>ToggleTerm direction=horizontal<cr>')
vim.keymap.set('n', '<leader>tl', '<cmd>ToggleTerm direction=vertical<cr>')
vim.keymap.set('n', '<leader>tk', '<cmd>ToggleTerm direction=float<cr>')
-- lazygit
vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>', { desc = "LazyGit" })
-- sessions
vim.keymap.set('n', '<leader>ss', '<cmd>mksession! session.vim<cr>', { desc = "Save session" } )
vim.keymap.set('n', '<leader>sl', '<cmd>source session.vim<cr>', { desc = "Load session" } )
-- Lazy
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = "Lazy plugin manager" })
-- Mason
vim.keymap.set('n', '<leader>M', '<cmd>Mason<cr>', { desc = "Mason lsp plugin manager" })
