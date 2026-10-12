return { -- Saves a session per directory (and git branch) on exit; restore with <leader>Ss or `s` on the dashboard
  'folke/persistence.nvim',
  event = 'BufReadPre', -- only start tracking once a real file is opened
  opts = {},
  keys = {
    {
      '<leader>Ss',
      function()
        require('persistence').load()
      end,
      desc = 'Restore session for this directory',
    },
    {
      '<leader>Sl',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Restore [L]ast session',
    },
    {
      '<leader>SS',
      function()
        require('persistence').select()
      end,
      desc = '[S]elect a session',
    },
    {
      '<leader>Sd',
      function()
        require('persistence').stop()
      end,
      desc = "[D]on't save this session",
    },
  },
}
