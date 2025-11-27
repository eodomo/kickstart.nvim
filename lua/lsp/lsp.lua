return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'saghen/blink.cmp', -- Auto-complete engine
    { 'folke/lazydev.nvim', opts = {} },
    { 'j-hui/fidget.nvim', opts = {} }, -- Loading notifications in the bottom-right corner
  },
  config = function()
    -- Global LSP attach autocmd (unchanged)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- Setup Mason and ensure tool installation (unchanged)
    require('mason').setup()
    local servers = { 'clangd', 'rust_analyzer', 'powershell_es', 'lua_ls', 'gopls' } -- Add others if desired
    local ensure_installed = vim.deepcopy(servers)
    vim.list_extend(ensure_installed, { 'stylua' })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Configure each LSP server using the new API
    vim.lsp.config('clangd', {})
    vim.lsp.config('rust_analyzer', {})
    vim.lsp.config('gopls', {})
    local install_dir = vim.fn.stdpath 'data' .. '/mason/packages/powershell-editor-services'
    vim.lsp.config('powershell_es', {
      cmd = {
        'pwsh',
        '-NoLogo',
        '-NoProfile',
        '-Command',
        install_dir .. '/PowerShellEditorServices/Start-EditorServices.ps1',
        '-HostName',
        'nvim',
        '-HostProfileId',
        'nvim',
        '-HostVersion',
        '1.0.0',
        '-BundledModulesPath',
        install_dir .. '/PowerShellEditorServices',
        '-LogPath',
        vim.fn.stdpath 'cache' .. '/powershell_es.log',
        '-SessionDetailsPath',
        vim.fn.stdpath 'cache' .. '/powershell_es.session.json',
        '-FeatureFlags',
        '@()',
        '-LogLevel',
        'Normal',
      },
      init_options = { enableProfileLoading = false },
      filetypes = { 'ps1' },
      on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      end,
      settings = { powershell = { codeFormatting = { Preset = 'OTBS' } } },
    })
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          diagnostics = { disable = { 'missing-fields' } },
          workspace = { library = { '${3rd}/love2d/library' } },
        },
      },
    })

    local godot_config = function()
      if vim.fn.has 'win32' then
        return {
          cmd = { 'ncat', '127.0.0.1', '6005' },
          name = 'godot',
        }
      else
        return {
          cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
          name = 'godot',
        }
      end
    end
    vim.lsp.config('gdscript', godot_config())

    -- Enable all configured servers
    vim.lsp.enable(servers)
    -- TODO: Fix godot LSP integration
    -- vim.lsp.enable 'gdscript'

    -- Optionally: extra LSP plugins (unmodified usage, if applicable)
    -- lazydev, fidget, blink.cmp already declared as dependencies above
  end,
}
