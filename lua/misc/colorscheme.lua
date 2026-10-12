return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  ---@module 'catppuccin'
  ---@type CatppuccinOptions
  opts = {
    flavour = 'mocha', -- <leader>tt switches to latte
    styles = { comments = {} }, -- no italic comments
    custom_highlights = function(colors)
      return {
        ColorColumn = { bg = colors.mantle }, -- keep the column-80 guide subtle
      }
    end,
    -- Plugin integrations (blink, snacks, which-key, gitsigns, mini, trouble, ...) are detected from lazy.nvim
    auto_integrations = true,
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
