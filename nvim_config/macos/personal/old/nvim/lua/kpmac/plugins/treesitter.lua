return {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = {
        'windwp/nvim-ts-autotag',
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require('nvim-treesitter.configs')

        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
                'c',
                'cpp',
                'cmake',
                'python',
                'make',
                'rust',
                'perl',
                'ruby',
                'php',
                'java',
                'json',
                'javascript',
                'typescript',
                'tsx',
                'yaml',
                'toml',
                'html',
                'css',
                'markdown',
                'markdown_inline',
                'bash',
                'lua',
                'vim',
                'dockerfile',
                'gitignore',
                'vimdoc',
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<leader>ss',
                    node_incremental = '<leader>ss',
                    scope_incremental = false,
                    node_decremental = '<bs>',
                },
            },
        })
    end,
}
