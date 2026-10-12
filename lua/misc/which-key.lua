return { -- Shows pending keybinds
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>l', group = '[L]aunch' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>x', group = 'Trouble' },
    },
  },
}
