return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    vim.filetype.add { extension = { j2 = 'jinja', jinja2 = 'jinja' } }

    local parsers = {
      'bash',
      'c',
      'css',
      'dockerfile',
      'go',
      'html',
      'ini',
      'javascript',
      'jinja',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    }
    local enabled = {}
    for _, parser in ipairs(parsers) do
      enabled[parser] = true
    end
    local available = {}
    for _, parser in ipairs(require('nvim-treesitter').get_available()) do
      available[parser] = true
    end
    local installing = {}

    vim.treesitter.language.register('powershell', 'ps1')

    -- Windows curl fails TLS handshakes with GitHub on this machine.
    local msys_curl = 'C:/msys64/usr/bin/curl.exe'
    if vim.fn.has 'win32' == 1 and vim.fn.executable(msys_curl) == 1 then
      vim.env.PATH = 'C:/msys64/usr/bin;' .. vim.env.PATH
    end

    -- Check for missing parsers after the first buffer is on screen.
    vim.defer_fn(function()
      require('nvim-treesitter').install(parsers, { max_jobs = 2 })
    end, 1000)

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Install and enable Treesitter highlighting',
      group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end

        local function start(buf)
          if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
            return false
          end

          local ok = pcall(vim.treesitter.start, buf)
          if ok and enabled[language] and vim.bo[buf].filetype ~= 'ruby' then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
          return ok
        end

        if start(event.buf) or not available[language] or installing[language] then
          return
        end

        installing[language] = true
        require('nvim-treesitter').install({ language }):await(function(err, installed)
          installing[language] = nil
          if err or not installed then
            return
          end

          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local buf_lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
              if buf_lang == language then
                start(buf)
              end
            end
          end)
        end)
      end,
    })
  end,
}
