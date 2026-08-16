return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        -- Defer installation so it doesn't block startup
        vim.defer_fn(function()
            require("nvim-treesitter").install({ 
                'c', 'cpp', 'cmake', 'python', 'make', 'rust', 'go',
                'perl', 'ruby', 'php', 'java', 'json', 'javascript', 'typescript', 'tsx',
                'yaml', 'toml', 'html', 'css', 'markdown', 'markdown_inline', 'latex',
                'bash', 'lua', 'vim', 'dockerfile', 'gitignore', 'vimdoc',
            })
        end, 0)

        -- Native highlighting trigger
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
