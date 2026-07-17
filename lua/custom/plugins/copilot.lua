-- Copilot plugin using lazy.nvim conventions
-- Installs the community Lua wrapper for GitHub Copilot (zbirenbaum/copilot.lua)

return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  config = function()
    -- Basic setup: enable suggestions and map accept to <C-J>
    require('copilot').setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = { accept = '<C-J>' },
      },
      panel = { enabled = true },
    })

    -- Toggle panel with <leader>cp
    vim.keymap.set('n', '<leader>cp', ':Copilot panel toggle<CR>', { desc = 'Copilot: toggle panel' })
  end,
}
