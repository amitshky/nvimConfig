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
              file = false,
              folder = false,
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

  -- { -- LSP Configuration & Plugins
  --   'neovim/nvim-lspconfig',
  --   dependencies = {
  --     -- Automatically install LSPs and related tools to stdpath for Neovim
  --     { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  --     'williamboman/mason-lspconfig.nvim',
  --     'WhoIsSethDaniel/mason-tool-installer.nvim',
  --
  --     -- Useful status updates for LSP.
  --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  --     { 'j-hui/fidget.nvim', opts = {} },
  --
  --     -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
  --     -- used for completion, annotations and signatures of Neovim apis
  --     { 'folke/neodev.nvim', opts = {} },
  --   },
  --   config = function()
  --     --  This function gets run when an LSP attaches to a particular buffer.
  --     vim.api.nvim_create_autocmd('LspAttach', {
  --       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  --       callback = function(event)
  --         local map = function(keys, func, desc)
  --           vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  --         end
  --
  --         -- Jump to the definition of the word under your cursor.
  --         --  This is where a variable was first declared, or where a function is defined, etc.
  --         --  To jump back, press <C-t>.
  --         map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  --
  --         -- Find references for the word under your cursor.
  --         map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  --
  --         -- Jump to the implementation of the word under your cursor.
  --         --  Useful when your language has ways of declaring types without an actual implementation.
  --         map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  --
  --         -- -- Jump to the type of the word under your cursor.
  --         -- --  Useful when you're not sure what type a variable is and you want to see
  --         -- --  the definition of its *type*, not where it was *defined*.
  --         -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  --         --
  --         -- -- Fuzzy find all the symbols in your current document.
  --         -- --  Symbols are things like variables, functions, types, etc.
  --         -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  --         --
  --         -- -- Fuzzy find all the symbols in your current workspace.
  --         -- --  Similar to document symbols, except searches over your entire project.
  --         -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  --
  --         -- Rename the variable under your cursor.
  --         --  Most Language Servers support renaming across files, etc.
  --         map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  --
  --         -- Execute a code action, usually your cursor needs to be on top of an error
  --         -- or a suggestion from your LSP for this to activate.
  --         map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  --
  --         -- Opens a popup that displays documentation about the word under your cursor
  --         --  See `:help K` for why this keymap.
  --         map('K', vim.lsp.buf.hover, 'Hover Documentation')
  --
  --         -- WARN: This is not Goto Definition, this is Goto Declaration.
  --         --  For example, in C this would take you to the header.
  --         map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  --
  --         -- The following two autocommands are used to highlight references of the
  --         -- word under your cursor when your cursor rests there for a little while.
  --         --    See `:help CursorHold` for information about when this is executed
  --         --
  --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
  --         -- local client = vim.lsp.get_client_by_id(event.data.client_id)
  --         -- if client and client.server_capabilities.documentHighlightProvider then
  --         --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
  --         --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --         --     buffer = event.buf,
  --         --     group = highlight_augroup,
  --         --     callback = vim.lsp.buf.document_highlight,
  --         --   })
  --         --
  --         --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --         --     buffer = event.buf,
  --         --     group = highlight_augroup,
  --         --     callback = vim.lsp.buf.clear_references,
  --         --   })
  --         --
  --         --   vim.api.nvim_create_autocmd('LspDetach', {
  --         --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
  --         --     callback = function(event2)
  --         --       vim.lsp.buf.clear_references()
  --         --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
  --         --     end,
  --         --   })
  --         -- end
  --
  --         -- The following autocommand is used to enable inlay hints in your
  --         -- code, if the language server you are using supports them
  --         --
  --         -- This may be unwanted, since they displace some of your code
  --         -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
  --         --   map('<leader>th', function()
  --         --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  --         --   end, '[T]oggle Inlay [H]ints')
  --         -- end
  --       end,
  --     })
  --
  --     -- LSP servers and clients are able to communicate to each other what features they support.
  --     --  By default, Neovim doesn't support everything that is in the LSP specification.
  --     --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --     --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  --
  --     -- Enable the following language servers
  --     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --     --
  --     --  Add any additional override configuration in the following tables. Available keys are:
  --     --  - cmd (table): Override the default command used to start the server
  --     --  - filetypes (table): Override the default list of associated filetypes for the server
  --     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --     --  - settings (table): Override the default settings passed when initializing the server.
  --     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  --     local servers = {
  --       -- clangd = {},
  --       -- gopls = {},
  --       -- pyright = {},
  --       -- rust_analyzer = {},
  --       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --       --
  --       -- Some languages (like typescript) have entire language plugins that can be useful:
  --       --    https://github.com/pmizio/typescript-tools.nvim
  --       --
  --       -- But for many setups, the LSP (`tsserver`) will work just fine
  --       -- tsserver = {},
  --       --
  --
  --       lua_ls = {
  --         -- cmd = {...},
  --         -- filetypes = { ...},
  --         -- capabilities = {},
  --         settings = {
  --           Lua = {
  --             completion = {
  --               callSnippet = 'Replace',
  --             },
  --             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
  --             -- diagnostics = { disable = { 'missing-fields' } },
  --           },
  --         },
  --       },
  --     }
  --
  --     -- Ensure the servers and tools above are installed
  --     --  To check the current status of installed tools and/or manually install
  --     --  other tools, you can run
  --     --    :Mason
  --     --
  --     --  You can press `g?` for help in this menu.
  --     require('mason').setup()
  --
  --     -- -- You can add other tools here that you want Mason to install
  --     -- -- for you, so that they are available from within Neovim.
  --     -- local ensure_installed = vim.tbl_keys(servers or {})
  --     -- vim.list_extend(ensure_installed, {
  --     --   'stylua', -- Used to format Lua code
  --     -- })
  --     require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  --
  --     require('mason-lspconfig').setup {
  --       handlers = {
  --         function(server_name)
  --           local server = servers[server_name] or {}
  --           -- This handles overriding only values explicitly passed
  --           -- by the server configuration above. Useful when disabling
  --           -- certain features of an LSP (for example, turning off formatting for tsserver)
  --           server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  --           require('lspconfig')[server_name].setup(server)
  --         end,
  --       },
  --     }
  --   end,
  -- },
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
vim.o.foldmethod="manual"
vim.o.foldenable=false
vim.o.foldnestmax=4
vim.o.splitbelow=true
vim.o.splitright=true

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
