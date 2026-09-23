return {
    "TheLeoP/powershell.nvim",
    event = { 'BufReadPre *.ps1', 'BufNewFile *.ps1' },
    ---@type powershell.user_config
    opts = {
      bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
    },
    config = function(_, opts)
      -- A stale session file makes powershell.nvim resume its coroutine too early.
      vim.fn.delete(vim.fn.stdpath 'cache' .. '/powershell_es.session.json')
      require('powershell').setup(opts)
    end,
}
