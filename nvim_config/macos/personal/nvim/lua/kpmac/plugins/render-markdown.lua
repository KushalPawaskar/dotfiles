return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = { lsp = { enabled = true } },
        latex = {
            enabled = false,        -- not great for multiline expressions, consider trying in the future or trying render-latex.nvim when it improves
            render_modes = false,
            converter = { 'utftex' },
            inline = true,
            block = true,
            highlight = 'RenderMarkdownMath',
            position = 'center',
            top_pad = 1,
            bottom_pad = 1,
        },
    },
}
