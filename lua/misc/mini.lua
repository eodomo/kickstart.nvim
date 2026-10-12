return { -- Collection of small independent plugins
  'echasnovski/mini.nvim',
  config = function()
    -- Better around/inside textobjects, e.g. va) yinq ci'
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings, e.g. saiw) sd' sr)'
    require('mini.surround').setup()

    -- Open buffers along the top
    require('mini.tabline').setup { show_icons = vim.g.have_nerd_font }

    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
