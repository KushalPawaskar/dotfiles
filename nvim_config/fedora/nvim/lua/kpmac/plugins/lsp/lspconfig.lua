return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        { 'antosha417/nvim-lsp-file-operations', config = true },
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require('lspconfig')

        -- import mason_lspconfig plugin
        local mason_lspconfig = require('mason-lspconfig')

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require('cmp_nvim_lsp')

        local keymap = vim.keymap -- for conciseness

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- set keybinds
                opts.desc = 'Show LSP references'
                keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- show definition, references

                opts.desc = 'Go to declaration'
                keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = 'Show LSP definitions'
                keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- show lsp definitions

                opts.desc = 'Show LSP implementations'
                keymap.set('n', 'gI', vim.lsp.buf.implementation, opts) -- show lsp implementations

                opts.desc = 'Show LSP type definitions'
                keymap.set('n', '<leader>d', vim.lsp.buf.type_definition, opts) -- show lsp type definitions

                opts.desc = 'See available code actions'
                keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = 'Smart rename'
                keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = 'Show buffer diagnostics'
                keymap.set('n', '<leader>E', vim.diagnostic.show, opts) -- show  diagnostics for file

                opts.desc = 'Show line diagnostics'
                keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = 'Go to previous diagnostic'
                keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = 'Go to next diagnostic'
                keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = 'Show documentation for what is under cursor'
                keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = 'Add buffer diagnostics to the location list'
                keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

                opts.desc = 'Restart LSP'
                keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary
            end,
        })

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end

        mason_lspconfig.setup_handlers({
            -- default handler for installed servers
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ['pylsp'] = function()
                -- configure python server
                lspconfig['pylsp'].setup({
                    capabilities = capabilities,
                    settings = {
                        pylsp = {
                            plugins = {
                                pycodestyle = {
                                    ignore = {      -- https://www.flake8rules.com
                                        'W291',     -- trailing whitespace (whitespace after final character of a line)
                                        'W293',     -- blank line contains whitespace
                                    },
                                    maxLineLength = 120
                                },
                            },
                        },
                    },
                })
            end,
            ['lua_ls'] = function()
                -- configure lua server (with special settings)
                lspconfig['lua_ls'].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            -- make the language server recognize 'vim' global
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                            runtime = {
                                -- tell the language server which version of Lua you are using (most likely LuaJIT in the case of neovim)
                                version = 'LuaJIT',
                            },
                            workspace = {
                                -- make the server aware of neovim runtime files
                                library = vim.api.nvim_get_runtime_file('', true),
                            },
                            telemetry = {
                                -- do not send telemetry containing a randomized but unique identifier
                                enable = false,
                            },
                        },
                    },
                })
            end,
            ['clangd'] = function()
                -- configure clang server with special settings
                -- When Packer was used: Do not add clangd in ensure_installed{}, clangd is already installed in /Library/Developer/CommandLineTools/usr/bin/clangd. Mason will install at a different location and then you will have to take care of all issues involving PATH of header files, namespace issues, etc.
                -- But in Lazy, add clangd to ensure_installed{}, the system one doesn't get detected and the installed one is able to find everything nicely
                lspconfig['clangd'].setup({
                    capabilities = capabilities,
                    init_options = {
                        fallbackFlags = { '--std=c++17' },      -- https://www.reddit.com/r/neovim/comments/19f7s3r/how_do_i_get_my_lsp_clangd_to_use_a_specific/
                    },
                })
            end,
        })
    end,
}
