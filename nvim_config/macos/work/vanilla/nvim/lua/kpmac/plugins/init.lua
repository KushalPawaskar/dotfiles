-- Plugins initialization
-- Load all plugin configurations

-- Only load plugins when not in VSCode
if not vim.g.vscode then
    -- Load LSP configurations
    require('kpmac.plugins.lsp.completion')
    require('kpmac.plugins.lsp.ty')
    require('kpmac.plugins.lsp.ruff')
end

