return {
    'folke/which-key.nvim',     -- shows key mappings when a key is pressed
    event = 'VeryLazy',
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
    },
}
