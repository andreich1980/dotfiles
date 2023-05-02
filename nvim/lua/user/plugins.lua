local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Initialize packer
require('packer').reset()
require('packer').init({
  compile_path = vim.fn.stdpath('data')..'/site/plugin/packer_compiled.lua',
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'solid' })
    end,
  },
})

local use = require('packer').use

-- Update packer
use('wbthomason/packer.nvim')

-- Color scheme
use({
  'folke/tokyonight.nvim',
  config = function()
    vim.cmd('colorscheme tokyonight')

    vim.api.nvim_set_hl(0, 'StatusLineNonText', {
      fg = vim.api.nvim_get_hl_by_name('NonText', true).foreground,
      bg = vim.api.nvim_get_hl_by_name('StatusLine', true).background,
    })
  end,
})


-- Commenting support
use('tpope/vim-commentary')

-- Add, change, and delete surrounding text
use('tpope/vim-surround')

-- Pairs of handy bracket mappings, like [b and ]b
use('tpope/vim-unimpaired')

-- Indent autodetection with editorconfig files
-- use ('tpope/vim-sleuth')

-- Allow plugins to enable repeating of commands
use('tpope/vim-repeat')

-- Add more languages
use('sheerun/vim-polyglot')

-- Jump to the last location when opening a file
use('farmergreg/vim-lastplace')

-- Enable * searching with visually selected text
use('nelstrom/vim-visual-star-search')

-- Automatically create parent dirs when saving
use('jessarcher/vim-heritage')

-- Text objects for HTLM attributes (x)
use({
  'whatyouhide/vim-textobj-xmlattr',
  requires = 'kana/vim-textobj-user',
})

use({
  'airblade/vim-rooter',
  setup = function()
    vim.g.rooter_manual_only = 1
  end,
  config = function()
    vim.cmd('Rooter')
  end,
})

use({
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup()
  end,
})

-- Smooth scrolling
use({
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup()
  end,
})

-- Split and join arrays, attributes (gS - split, gJ - join)
use({
    'AndrewRadev/splitjoin.vim',
    config = function()
      vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
      vim.g.splitjoin_trailing_comma = 1; vim.g.splitjoin_php_method_chain_full = 1
    end,
})

-- Fix indentation when pasting code
use({
    'sickill/vim-pasta',
    config = function()
      vim.g.pasta_disabled_filetypes = {'fugitive'}
    end,
})

-- Fuzzy finder
use({
  'nvim-telescope/telescope.nvim',
  requires = {
    { 'nvim-lua/plenary.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  },
  config = function()
    require('user.plugins.telescope')
  end,
})

-- File tree sidebar
use({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.nvim-tree')
  end,
})


-- A status line
use({
  'nvim-lualine/lualine.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('user.plugins.lualine')
  end,
})


use({
  'akinsho/bufferline.nvim',
  require = 'kyazdani42/nvim-web-devicons',
  after = 'tokyonight.nvim',
  config = function()
    require('user.plugins.bufferline')
  end,
})

use({
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('user.plugins.indent-blankline')
  end,
})

-- use({
--   'glepnir/dashboard-nvim',
--   require = 'kyazdani42/nvim-web-devicons',
--   config = function()
--     require('user.plugins.dashboard-nvim')
--   end,
-- })

use({
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
    vim.keymap.set('n', ']h', ':Gitsigns next_hunk<CR>')
    vim.keymap.set('n', '[h', ':Gitsigns prev_hunk<CR>')
    vim.keymap.set('n', 'gs', ':Gitsigns stage_hunk<CR>')
    vim.keymap.set('n', 'gS', ':Gitsigns undo_stage_hunk<CR>')
    vim.keymap.set('n', 'gp', ':Gitsigns preview_hunk<CR>')
    vim.keymap.set('n', 'gb', ':Gitsigns blame_line<CR>')
  end
})

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
    require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])

