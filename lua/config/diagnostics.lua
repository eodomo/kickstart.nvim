-- [[ Diagnostics ]]
-- See `:help vim.diagnostic.Opts`

local severity = vim.diagnostic.severity

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [severity.ERROR] = '󰅚 ',
      [severity.WARN] = '󰀪 ',
      [severity.INFO] = '󰋽 ',
      [severity.HINT] = '󰌶 ',
    },
  } or {},
  -- Show the message inline only on the cursor's line; `<leader>e` opens the full float
  virtual_text = { current_line = true, source = 'if_many', spacing = 2 },
}
