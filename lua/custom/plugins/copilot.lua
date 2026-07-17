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

    -- Simple chat UI: :CopilotChat opens (or reuses) a right-side chat buffer and prompts for input
    local chat_buf = nil
    local chat_win = nil

    local function ensure_loaded()
      if not pcall(require, 'copilot') then
        -- try to trigger lazy.nvim loader
        pcall(vim.cmd, 'Lazy load copilot.lua')
      end
    end

    local function open_chat_window()
      if chat_buf and vim.api.nvim_buf_is_valid(chat_buf) then
        -- reuse
      else
        chat_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(chat_buf, 'CopilotChat')
        vim.api.nvim_buf_set_option(chat_buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(chat_buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(chat_buf, 'swapfile', false)
        vim.api.nvim_buf_set_option(chat_buf, 'filetype', 'copilot-chat')
        vim.api.nvim_buf_set_option(chat_buf, 'modifiable', false)
      end

      local width = math.max(40, math.floor(vim.o.columns * 0.40))
      local height = math.max(8, math.floor(vim.o.lines * 0.6))
      local row = 1
      local col = vim.o.columns - width - 1

      if chat_win and vim.api.nvim_win_is_valid(chat_win) then
        vim.api.nvim_set_current_win(chat_win)
      else
        local opts = {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
        }
        chat_win = vim.api.nvim_open_win(chat_buf, true, opts)
      end
    end

    local function append_chat(prefix, text)
      if not (chat_buf and vim.api.nvim_buf_is_valid(chat_buf)) then return end
      vim.api.nvim_buf_set_option(chat_buf, 'modifiable', true)
      local lines = {}
      for s in string.gmatch(text, '[^\n]+') do table.insert(lines, s) end
      vim.api.nvim_buf_set_lines(chat_buf, -1, -1, false, { prefix })
      vim.api.nvim_buf_set_lines(chat_buf, -1, -1, false, lines)
      vim.api.nvim_buf_set_option(chat_buf, 'modifiable', false)
      -- scroll to bottom
      if chat_win and vim.api.nvim_win_is_valid(chat_win) then
        vim.api.nvim_win_set_cursor(chat_win, { vim.api.nvim_buf_line_count(chat_buf), 0 })
      end
    end

    local function try_send_prompt(prompt)
      if not prompt or prompt == '' then return end
      ensure_loaded()
      append_chat('You: ', prompt)

      local ok, api = pcall(require, 'copilot.api')
      if ok and api then
        -- Try a few possible API entry points (best-effort)
        local tried = false
        local handlers = {
          function()
            if api.request then
              local res = api.request(prompt)
              if res then append_chat('Copilot: ', tostring(res)) end
              tried = true
            end
          end,
          function()
            if api.chat then
              local res = api.chat(prompt)
              if res then append_chat('Copilot: ', tostring(res)) end
              tried = true
            end
          end,
          function()
            if api.run then
              local res = api.run('request', prompt)
              if res then append_chat('Copilot: ', tostring(res)) end
              tried = true
            end
          end,
        }
        for _, fn in ipairs(handlers) do
          local ok2, err = pcall(fn)
          if ok2 and tried then break end
        end
        if not tried then
          append_chat('Copilot: ', 'copilot.api present but no known request method. Open :Copilot panel or check plugin docs.')
        end
      else
        -- fallback: open panel and instruct
        append_chat('Copilot: ', 'Copilot API not available. Opening panel as fallback...')
        pcall(vim.cmd, 'Copilot panel open')
      end
    end

    vim.api.nvim_create_user_command('CopilotChat', function(opts)
      open_chat_window()
      vim.defer_fn(function()
        vim.ui.input({ prompt = 'Copilot: ' }, function(input)
          try_send_prompt(input)
        end)
      end, 20)
    end, { nargs = 0 })

    -- keymap to open chat
    vim.keymap.set('n', '<leader>cC', ':CopilotChat<CR>', { desc = 'Copilot: open chat' })
  end,
}
