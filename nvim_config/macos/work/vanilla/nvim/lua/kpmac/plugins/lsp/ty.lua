-- Ty Language Server Configuration (Type Checker from astral-sh)
-- https://github.com/astral-sh/ty

local M = {}

-- Find project root based on common Python project markers
local function find_root(markers)
    return vim.fs.dirname(vim.fs.find(markers, {
        upward = true,
        path = vim.fn.expand('%:p:h'),
    })[1])
end

-- LSP configuration for ty
local function get_config()
    local root_dir = find_root({ 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' })
        or vim.fn.getcwd()

    return {
        name = 'ty',
        cmd = { 'ty', 'server' },
        root_dir = root_dir,
        filetypes = { 'python' },
        settings = {},
    }
end

-- Start ty LSP server for Python files
function M.setup()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        group = vim.api.nvim_create_augroup('TyLsp', { clear = true }),
        callback = function()
            vim.lsp.start(get_config())
        end,
        desc = 'Start ty language server for Python files',
    })
end

-- Initialize
M.setup()

return M

