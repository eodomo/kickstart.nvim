-- [[ Autocommands ]]
-- See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Relative numbers only in the focused window outside insert mode, so anyone watching
-- sees real line numbers everywhere else. `vim.g.relative_number = false` turns them off
-- entirely (see the <leader>tr and <leader>tp toggles in misc/snacks.lua).
vim.g.relative_number = true

local number_group = vim.api.nvim_create_augroup('number-toggle', { clear = true })

local function set_relative(relative)
  if vim.wo.number then
    vim.wo.relativenumber = relative and vim.g.relative_number
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  desc = 'Relative numbers in the focused window',
  group = number_group,
  callback = function()
    set_relative(vim.api.nvim_get_mode().mode ~= 'i')
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  desc = 'Absolute numbers in unfocused windows and insert mode',
  group = number_group,
  callback = function()
    set_relative(false)
  end,
})
