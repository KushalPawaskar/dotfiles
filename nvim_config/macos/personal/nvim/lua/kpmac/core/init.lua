if vim.g.vscode then
    require("kpmac.core.vscode_keymaps")
    require("kpmac.core.vscode_options")
else
    -- Load options
    require('kpmac.core.options')

    -- Load keymaps
    require('kpmac.core.keymaps')

    -- Load functions
    require('kpmac.core.functions')
end
