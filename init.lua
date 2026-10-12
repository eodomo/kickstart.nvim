-- Leader must be set before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'config.options'
require 'config.diagnostics'
require 'config.keymaps'
require 'config.autocmds'

-- [[ Bootstrap lazy.nvim ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
-- Every .lua file in these directories returns a lazy spec. Rename to .txt to disable one.
require('lazy').setup({
  require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.lint',
  { import = 'custom.plugins' },
  { import = 'misc' },
  { import = 'lsp' },
}, {
  install = { colorscheme = { 'catppuccin' } },
  ui = { border = 'rounded' },
})

-- vim: ts=2 sts=2 sw=2 et
