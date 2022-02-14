--[[
______ _             _
| ___ \ |           (_)
| |_/ / |_   _  __ _ _ _ __  ___
|  __/| | | | |/ _` | | '_ \/ __|
| |   | | |_| | (_| | | | | \__ \
\_|   |_|\__,_|\__, |_|_| |_|___/
                __/ |
               |___/
--]]

if package.config:sub(1,1) == "/" then
  OperatingSystem = "unix"
else
  OperatingSystem = "windows"
end

-- after loading the basic settings, let's check if packer is
-- installed before loading a shitload of errors:
local fn = vim.fn
local install_path

if OperatingSystem == "unix" then
  install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
else
  install_path = fn.stdpath('data')..'\\site\\pack\\packer\\start\\packer.nvim'
end

if fn.empty(fn.glob(install_path)) > 0 then
  print("Installing packer to: " .. install_path)
  Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("installed packer")
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.startup(function(use)
  -- use this commit for now, windows support is broken
  use {
    "wbthomason/packer.nvim",
    commit = "62a69fb4cc995d17688a015df1f0bf890d9a201c",
    as = "packer"
}

  -- LSP and code navigation
  -- ------------------------------------
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use "ray-x/lsp_signature.nvim"
  use "hrsh7th/cmp-nvim-lua"
  use "folke/lua-dev.nvim"
  -- Can't figure out how to make this one work...
  use 'jubnzv/virtual-types.nvim'
  use 'j-hui/fidget.nvim'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'glepnir/lspsaga.nvim'
  use {'stevearc/aerial.nvim'}
  use { "michaelb/sniprun", run = "bash ./install.sh" }
  use 'honza/vim-snippets'
  use 'terrortylor/nvim-comment'
  use 'jose-elias-alvarez/null-ls.nvim'

  -- Syntax highlighter
  -- ---------------------
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use "romgrk/nvim-treesitter-context"

  -- Theme / UI
  -- -----------------
  use({
    "catppuccin/nvim",
    as = "catppuccin"
  })
  use 'rcarriga/nvim-notify'
  use 'norcalli/nvim-colorizer.lua'
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    }
  }
  use {
   'nvim-lualine/lualine.nvim',
   requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use "lukas-reineke/indent-blankline.nvim"
  use {'stevearc/dressing.nvim'}

  -- Terminal emulator
  -- ---------------------
  use "akinsho/toggleterm.nvim"

  -- Search tools
  -- --------------
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'ibhagwan/fzf-lua',
  -- optional for icon support
  requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  
  use "windwp/nvim-autopairs"
  use "ahmedkhalf/project.nvim"
  use "Shatur/neovim-session-manager"



  if Packer_bootstrap then
    require('packer').sync()
  end

end)