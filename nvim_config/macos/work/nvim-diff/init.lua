-- ~/.config/nvim-diff/init.lua

vim.g.diff_mode = true

-- Add your main nvim config to runtimepath
local main_config = vim.fn.stdpath("config"):gsub("nvim%-diff", "nvim")
vim.opt.runtimepath:append(main_config)

-- Load shared config
require("kpmac.core.options")
require("kpmac.core.keymaps")

-- Diff keymaps
vim.keymap.set("n", "<leader>l", "<cmd>diffget LOCAL<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>diffget REMOTE<cr>")

-- options
vim.opt.timeoutlen = 200    -- default is 1000 ms
