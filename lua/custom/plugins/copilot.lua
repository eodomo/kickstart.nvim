-- Copilot plugin using lazy.nvim conventions
-- Installs the community Lua wrapper for GitHub Copilot (zbirenbaum/copilot.lua)

return {
  'zbirenbaum/copilot.lua',
  -- Load on InsertEnter for suggestions, but also expose the :Copilot command and keymaps so users can open the panel anytime
  event = 'InsertEnter',
  cmd = 'Copilot',
  keys = {
    { '<leader>cp', ':Copilot panel toggle<CR>', desc = 'Copilot: toggle panel' },
    { '<leader>cr', '<cmd>lua require("copilot.suggestion").next()<CR>', desc = 'Copilot: request suggestion' },
    { '<leader>ca', '<cmd>lua require("copilot.suggestion").accept()<CR>', desc = 'Copilot: accept suggestion' },
    { '<leader>cd', '<cmd>lua require("copilot.suggestion").dismiss()<CR>', desc = 'Copilot: dismiss suggestion' },
  },
  config = function()
    -- Basic setup: enable suggestions and map accept to <C-J>
    require('copilot').setup({
      suggestion = {
        enabled = true,
        auto_trigger = false, -- manual request-only mode
        hide_during_completion = true,
        keymap = { accept = '<C-J>' },
      },
      panel = { enabled = true },
    })

    -- mappings using <leader>c* prefix (avoid starting with plain 'c')
    vim.keymap.set('n', '<leader>cp', ':Copilot panel toggle<CR>', { desc = 'Copilot: toggle panel' })
    vim.keymap.set('n', '<leader>cr', function() require('copilot.suggestion').next() end, { desc = 'Copilot: request suggestion' })
    vim.keymap.set('n', '<leader>ca', function() require('copilot.suggestion').accept() end, { desc = 'Copilot: accept suggestion' })
    vim.keymap.set('n', '<leader>cd', function() require('copilot.suggestion').dismiss() end, { desc = 'Copilot: dismiss suggestion' })
  end,
}
