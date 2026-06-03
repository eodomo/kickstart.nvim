return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      eruby = { 'erb_format' },
      html = { 'prettier' },
      json = { 'prettier' },
      svelte = { 'prettier' },
      typescript = { 'prettier' },
    },
    format_on_save = {
      timeout_ms = 1500,
      lsp_fallback = true,
    },
    formatters = {
      prettier = {
        prepend_args = { '--tab-width', '4' },
      },
    },
  },
}
