-- [[ Keymaps ]]
-- Plugin keymaps live in their plugin specs; toggles (<leader>t) are in misc/snacks.lua.

local map = vim.keymap.set

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Buffers
map('n', '<leader><Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<leader><S-Tab>', '<cmd>bprev<CR>', { desc = 'Previous buffer' })

-- Windows: CTRL+<hjkl> to move focus
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal: <Esc><Esc> instead of <C-\><C-n>
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Misc
map('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndotree' })
map('n', '<leader>ll', '<cmd>!love .<CR>', { desc = 'Run [L]ÖVE' })
map('n', 'gs', '^', { desc = 'Go to first non-blank character' })
vim.api.nvim_create_user_command('W', 'w', {})

-- Toggle the word under cursor between 'true' and 'false'
map('n', '<leader>~', function()
  local word = vim.fn.expand '<cword>'
  if word == 'true' then
    vim.cmd [[normal! ciwfalse]]
  elseif word == 'false' then
    vim.cmd [[normal! ciwtrue]]
  else
    vim.notify("Cursor not on 'true' or 'false'", vim.log.levels.INFO, { title = 'Toggle Boolean' })
  end
end, { desc = 'Toggle true/false under cursor' })
