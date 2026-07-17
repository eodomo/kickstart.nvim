-- Copilot plugin using lazy.nvim conventions
-- Installs the community Lua wrapper for GitHub Copilot (zbirenbaum/copilot.lua)

return {
  'zbirenbaum/copilot.lua',
  -- Load on InsertEnter for suggestions, but also expose the :Copilot command and keymaps so users can open the panel anytime
  event = 'InsertEnter',
  cmd = 'Copilot',
  -- lazy.nvim will create keymaps that load the plugin before executing the function
  keys = {
    { '<leader>cp', function()
        -- toggle the Copilot panel (lazy.nvim loads the plugin first)
        local ok, copilot = pcall(require, 'copilot')
        if not ok then
          -- attempt to trigger lazy.nvim loader by calling the :Copilot command
          pcall(vim.cmd, 'Lazy load copilot.lua')
        end
        -- now try to open the panel
        local ok2, panel = pcall(function()
          return require('copilot.panel')
        end)
        if ok2 and panel and panel.toggle then
          panel.toggle()
        else
          vim.defer_fn(function()
            -- fallback: try the command which should load and run
            pcall(vim.cmd, 'Copilot panel toggle')
          end, 50)
        end
      end, desc = 'Copilot: toggle panel' },
    { '<leader>cr', function()
        if not pcall(require, 'copilot') then pcall(vim.cmd, 'Lazy load copilot.lua') end
        pcall(function() require('copilot.suggestion').next() end)
      end, desc = 'Copilot: request suggestion' },
    { '<leader>ca', function()
        if not pcall(require, 'copilot') then pcall(vim.cmd, 'Lazy load copilot.lua') end
        pcall(function() require('copilot.suggestion').accept() end)
      end, desc = 'Copilot: accept suggestion' },
    { '<leader>cd', function()
        if not pcall(require, 'copilot') then pcall(vim.cmd, 'Lazy load copilot.lua') end
        pcall(function() require('copilot.suggestion').dismiss() end)
      end, desc = 'Copilot: dismiss suggestion' },
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

    -- Keep local mappings in case plugin already loaded; keys field also provides lazy mappings
    vim.keymap.set('n', '<leader>cp', function()
      local ok, panel = pcall(function() return require('copilot.panel') end)
      if ok and panel and panel.toggle then
        panel.toggle()
      else
        pcall(vim.cmd, 'Copilot panel toggle')
      end
    end, { desc = 'Copilot: toggle panel' })
  end,
}
