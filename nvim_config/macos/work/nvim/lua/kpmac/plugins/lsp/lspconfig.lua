return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/lazydev.nvim', opts = {} },
  },
  config = function()
    -- 1. Keymaps (using LspAttach)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
        end

        -- map('gr', vim.lsp.buf.references, 'References')              -- grr native nvim
        map('gd', vim.lsp.buf.definition, 'Definition')
        -- map('gy', vim.lsp.buf.type_definition, 'Type Definition')    -- grt native nvim
        map('gD', vim.lsp.buf.declaration, 'Declaration')
        map('gI', vim.lsp.buf.implementation, 'Implementation')
        vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'LSP: Signature Help' })
        -- map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')    -- gra native nvim
        -- map('<leader>rn', vim.lsp.buf.rename, 'Rename')              -- grn native nvim
        vim.keymap.set('n', '<leader>bf', function() vim.lsp.buf.format({ async = true }) end, { desc = 'LSP: Format Buffer' })
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        -- map('<leader>ds', vim.lsp.buf.document_symbol, 'Document Symbol')    -- gO (note that it is capital o) native nvim
      end,
    })

    -- 2. Diagnostics
    vim.diagnostic.config({
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.HINT] = '󰌵 ',
          [vim.diagnostic.severity.INFO] = ' ',
        },
      },
    })

    -- 3. Setup Servers (Native 0.12+ Pattern)
    local servers = {
      ruff = {},
      ty = {},
      lua_ls = {
        settings = {
          Lua = { completion = { callSnippet = "Replace" } }
        }
      },
    }

    for server, config in pairs(servers) do
      -- Inject blink capabilities
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      
      -- Set the config and enable the server (The modern lspconfig way)
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
