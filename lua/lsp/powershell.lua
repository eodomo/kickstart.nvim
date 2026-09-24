return {
    "TheLeoP/powershell.nvim",
    event = { 'BufReadPost *.ps1', 'BufNewFile *.ps1' },
    ---@type powershell.user_config
    opts = {
      bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
    },
    config = function(_, opts)
      -- A stale session file makes powershell.nvim resume its coroutine too early.
      vim.fn.delete(vim.fn.stdpath 'cache' .. '/powershell_es.session.json')
      local powershell = require('powershell')
      powershell.setup(opts)
      -- BufReadPost happens after the first FileType event.
      if vim.bo.filetype == 'ps1' then
        powershell.initialize_or_attach(vim.api.nvim_get_current_buf())
      end
    end,
}
