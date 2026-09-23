return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'folke/lazydev.nvim', opts = {} },
    { 'j-hui/fidget.nvim', opts = {} }, -- Loading notifications in the bottom-right corner
  },
  config = function()
    local function has_exe(cmd)
      return vim.fn.executable(cmd) == 1
    end
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

    -- Setup Mason and ensure tool installation
    require('mason').setup()
    local servers = { 'clangd', 'rust_analyzer', 'lua_ls', 'gopls' }
    if has_exe 'node' then
      table.insert(servers, 'pyright')
      table.insert(servers, 'svelte-language-server')
      table.insert(servers, 'prettier')
    end
    local ensure_installed = vim.deepcopy(servers)
    vim.list_extend(ensure_installed, { 'stylua', 'powershell-editor-services' })
    -- Tool checks can wait until the initial buffer is visible.
    vim.defer_fn(function()
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end, 1000)

    -- Configure each LSP server using the new API
    vim.lsp.config('clangd', {})
    vim.lsp.config('rust_analyzer', {})
    vim.lsp.config('gopls', {})
    if vim.tbl_contains(servers, 'pyright') then
      vim.lsp.config('pyright', {})
    end

    if vim.tbl_contains(servers, 'svelte-language-server') then
      vim.lsp.config('svelte-language-server', {})
    end
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
  end,
}
