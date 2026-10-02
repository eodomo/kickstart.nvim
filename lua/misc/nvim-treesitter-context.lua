return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    enable = true, -- Enable the plugin
    max_lines = 3, -- How many lines the context window can take up
    trim_scope = 'outer', -- Which context lines to discard if max_lines is exceeded
    mode = 'cursor', -- Line used to calculate context ('cursor' or 'topline')
  },
}
