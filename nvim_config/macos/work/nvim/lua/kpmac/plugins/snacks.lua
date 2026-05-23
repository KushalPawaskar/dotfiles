return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        indent = {
            enabled = true,
            indent = { char = "┊" },
        },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        picker = {
            enabled = true,
            ui_select = true,
            layout = { preset = "telescope" },
            matcher = {
                filename_bonus = true,
            },
            formatters = {
                file = {
                    truncate = "center",
                },
            },
            sources = {
                files = {
                    hidden = true,
                    ignored = false,
                },
                buffers = {
                    sort_lastused = true,
                },
            },
        },
        terminal = { enabled = true },
        words = { enabled = true },
        image = { enabled = false },
        zen = { enabled = true },
    },
    keys = {
        -- find (replacing telescope keymaps) (requires ripgrep, fd)
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
        { "<leader>fs", function() Snacks.picker.grep() end, desc = "Live grep" },
        { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fe", function() Snacks.explorer() end, desc = "File explorer" },
        { "<leader>cs", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

        -- LSP pickers
        { "<leader>sr", function() Snacks.picker.lsp_references() end, desc = "LSP references" },
        { "<leader>sy", function() Snacks.picker.lsp_symbols() end, desc = "LSP document symbols" },
        { "<leader>sY", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Project diagnostics" },

        -- buffers / terminal / references
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
        { "<c-/>", function() require("kpmac.terminals").toggle_shell() end, desc = "Toggle shell terminal" },
        { "<leader>tl", function() require("kpmac.terminals").cycle_shell_layout() end, desc = "Cycle shell terminal layout" },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- vim options
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.indent():map("<leader>ui")
                Snacks.toggle.dim():map("<leader>uD")

                -- snacks modules
                Snacks.toggle.zen():map("<leader>uz")
                Snacks.toggle.zoom():map("<leader>uZ")

                Snacks.toggle.new({     -- requires imagemagick for images, ghostscript for pdf files, pdflatex for latex math, mmdc for mermaid diagrams
                    id = "image",
                    name = "Image Viewer",
                    get = function()
                        return Snacks.config.image.enabled
                    end,
                    set = function(state)
                        Snacks.config.image.enabled = state
                        if state then
                            Snacks.image.setup()
                        end
                    end,
                }):map("<leader>uI")
            end,
        })
    end,
}
