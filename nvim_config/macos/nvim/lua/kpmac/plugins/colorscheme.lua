return {
    {
        'ellisonleao/gruvbox.nvim',
        lazy = true,       -- keeping this false for colorschemes not in use will increase startup time but if its true then the plugin won't even be loaded directly, i.e. it won't be available in :colorscheme. :Telescope colorscheme would have to be done to load it
        priority = 1000,    -- make sure to load this before all the other start plugins (works only when lazy = false)
        config = function ()
            -- import gruvbox
            local gruvbox = require("gruvbox")

            -- configure the colorscheme
            gruvbox.setup({
                dim_inactive = false,
                transparent_mode = false,
            })

            -- load the colorscheme
            -- vim.cmd("colorscheme gruvbox")
        end
    },
    {
        "oxfist/night-owl.nvim",
        name = "nightowl",
        lazy = false,       -- keeping this false for colorschemes not in use will increase startup time but if its true then the plugin won't even be loaded directly, i.e. it won't be available in :colorscheme. :Telescope colorscheme would have to be done to load it
        priority = 1000,    -- make sure to load this before all the other start plugins (works only when lazy = false)
        config = function()
            -- load the colorscheme
            vim.cmd.colorscheme("night-owl")
        end
    },
    {
        "yorumicolors/yorumi.nvim",
        lazy = false,       -- keeping this false for colorschemes not in use will increase startup time but if its true then the plugin won't even be loaded directly, i.e. it won't be available in :colorscheme. :Telescope colorscheme would have to be done to load it
        priority = 1000,    -- make sure to load this before all the other start plugins (works only when lazy = false)
        config = function ()
            -- load the colorscheme
            -- vim.cmd.colorscheme("yorumi-abyss")
        end
    },
    {
        "ribru17/bamboo.nvim",
        lazy = true,       -- keeping this false for colorschemes not in use will increase startup time but if its true then the plugin won't even be loaded directly, i.e. it won't be available in :colorscheme. :Telescope colorscheme would have to be done to load it
        priority = 1000,    -- make sure to load this before all the other start plugins (works only when lazy = false)
        config = function ()
            require("bamboo").setup()   -- giving errors without this line when loading multiplex or vulgaris variants

            -- load the colorscheme
            -- vim.cmd.colorscheme("bamboo-vulgaris")
        end
    },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     lazy = true,       -- keeping this false for colorschemes not in use will increase startup time but if its true then the plugin won't even be loaded directly, i.e. it won't be available in :colorscheme. :Telescope colorscheme would have to be done to load it
    --     priority = 1000,    -- make sure to load this before all the other start plugins (works only when lazy = false)
    --     config = function ()
    --         -- load the colorscheme
    --         -- vim.cmd("colorscheme catppuccin-mocha")
    --     end
    -- },
    -- {
    --     'rebelot/kanagawa.nvim',
    --     lazy = true,       -- keeping this false for colorschemes not in use will increase startup time but if its true then the plugin won't even be loaded directly, i.e. it won't be available in :colorscheme. :Telescope colorscheme would have to be done to load it
    --     priority = 1000,    -- make sure to load this before all the other start plugins (works only when lazy = false)
    --     config = function()
    --         -- load the colorscheme here
    --         vim.cmd('colorscheme kanagawa-wave')
    --     end,
    -- },
}
