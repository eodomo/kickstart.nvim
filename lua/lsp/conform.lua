return { -- Autoformat
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- No LSP fallback for languages without a standard style
      local no_lsp_fallback = { c = true, cpp = true }
      return {
        timeout_ms = 1500,
        lsp_format = no_lsp_fallback[vim.bo[bufnr].filetype] and 'never' or 'fallback',
      }
    end,
    formatters_by_ft = {
      eruby = { 'erb_format' },
      html = { 'prettier' },
      json = { 'prettier' },
      lua = { 'stylua' },
      svelte = { 'prettier' },
      typescript = { 'prettier' },
    },
    formatters = {
      prettier = {
        prepend_args = { '--tab-width', '4' },
      },
    },
  },
}
