-- Copilot plugin using lazy.nvim conventions
-- Installs the community Lua wrapper for GitHub Copilot (zbirenbaum/copilot.lua)

return {
  'zbirenbaum/copilot.lua',
  -- Load on InsertEnter for suggestions, but also expose the :Copilot command and a keymap so users can open the panel anytime
  event = 'InsertEnter',
  cmd = 'Copilot',
  keys = {
    { '<leader>cp', ':Copilot panel toggle<CR>', desc = 'Copilot: toggle panel' },
  },
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
  end,
}
