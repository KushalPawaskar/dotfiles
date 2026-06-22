return {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
        require("tree-sitter-manager").setup({
            ensure_installed = {
                'c', 'cpp', 'cmake', 'python', 'make', 'rust', 'perl', 'ruby', 
                'php', 'java', 'json', 'javascript', 'typescript', 'tsx', 
                'yaml', 'toml', 'html', 'css', 'markdown', 'markdown_inline', 'latex', 
                'bash', 'lua', 'vim', 'dockerfile', 'gitignore', 'vimdoc', 
            },
        })
    end,
}
