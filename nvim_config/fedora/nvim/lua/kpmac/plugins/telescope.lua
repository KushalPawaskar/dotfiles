return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function ()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                dynamic_preview_title = true,
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,    -- move to previous result
                        ["<C-j>"] = actions.move_selection_next,        -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,  -- send selections to quick fix list and open quick fix list (press tab to select/deselect results)
                    },
                },
            },
            pickers = {
                find_files = {
                    find_command = { "rg", "--files", "--hidden", "-g", "!.git" },      -- to show hidden files as well excluding the ones in .git
                },
                buffers = {
                    sort_mru = true,        -- sort buffers by most recently used
                },
            },
        })

        telescope.load_extension("fzf")

        -- set keymaps
        local keymap = vim.keymap

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find open buffers" })

    end
}
