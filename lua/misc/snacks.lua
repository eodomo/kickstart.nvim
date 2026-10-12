return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    git = { enabled = false },
    -- Only highlight the current block's indent guide, not every level
    indent = {
      enabled = true,
      indent = { enabled = false },
      scope = { enabled = true },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {},
      },
      win = {
        input = {
          keys = {
            ['<S-Tab>'] = { 'list_up', mode = { 'i', 'n' } },
            ['<Tab>'] = { 'list_down', mode = { 'i', 'n' } },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    -- Explorer
    {
      '<leader><leader>',
      function()
        Snacks.explorer()
      end,
      desc = 'File Explorer',
    },
    -- Search
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep in open [B]uffers',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch [W]ord',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Search in current buffer',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.notifications()
      end,
      desc = '[S]earch [N]otifications',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch [R]ecent',
    },
    -- LSP
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = '[G]oto [D]efinition',
    },
    {
      'gD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = '[G]oto [D]eclaration',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Toggles show their on/off state in which-key under <leader>t
        Snacks.toggle
          .new({
            id = 'light_theme',
            name = 'Light theme',
            get = function()
              return vim.g.colors_name == 'catppuccin-latte'
            end,
            set = function(state)
              vim.cmd.colorscheme(state and 'catppuccin-latte' or 'catppuccin-mocha')
            end,
          })
          :map '<leader>tt'

        Snacks.toggle
          .new({
            id = 'relative_number',
            name = 'Relative numbers',
            get = function()
              return vim.g.relative_number
            end,
            set = function(state)
              vim.g.relative_number = state
              if vim.wo.number then
                vim.wo.relativenumber = state
              end
            end,
          })
          :map '<leader>tr'

        Snacks.toggle.zen():map '<leader>tz'
        Snacks.toggle.dim():map '<leader>td'

        -- Presenter mode: absolute line numbers + zen (centered window, dims everything but the current block)
        Snacks.toggle
          .new({
            id = 'presenter',
            name = 'Presenter mode',
            get = function()
              return vim.g.presenter_mode == true
            end,
            set = function(state)
              vim.g.presenter_mode = state
              Snacks.toggle.get('relative_number'):set(not state)
              Snacks.toggle.get('zen'):set(state)
            end,
          })
          :map '<leader>tp'
      end,
    })
  end,
}
