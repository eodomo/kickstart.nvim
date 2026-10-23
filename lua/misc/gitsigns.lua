return { -- Git change markers in the sign column
  'lewis6991/gitsigns.nvim',
  keys = {
    { ']c', function() require('gitsigns').nav_hunk('next') end, desc = 'Git: Next change' },
    { '[c', function() require('gitsigns').nav_hunk('prev') end, desc = 'Git: Previous change' },
  },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▁' },
      topdelete = { text = '▔' },
      changedelete = { text = '▎' },
      untracked = { text = '┆' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▁' },
      topdelete = { text = '▔' },
      changedelete = { text = '▎' },
    },
  },
}
