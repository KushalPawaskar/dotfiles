return {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = {
        'windwp/nvim-ts-autotag',
    },
    -- Use the top-level module instead of the deleted .configs one
    main = 'nvim-treesitter', 
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        -- Ensure autotag is configured here if you want it enabled
        autotag = { enable = true },
        ensure_installed = {
            'c', 'cpp', 'cmake', 'python', 'make', 'rust', 'perl', 'ruby', 
            'php', 'java', 'json', 'javascript', 'typescript', 'tsx', 
            'yaml', 'toml', 'html', 'css', 'markdown', 'markdown_inline', 
            'bash', 'lua', 'vim', 'dockerfile', 'gitignore', 'vimdoc',
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
    },
}
