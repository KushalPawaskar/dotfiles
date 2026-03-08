local M = {}

-- export nice color schemes so that it is accessible to InputSelector in keys.lua
M.nice_color_schemes = {
    "Argonaut (Gogh)",
    "ayu",
    "Builtin Pastel Dark",
    "Cloud (terminal.sexy)"
}

function M.apply(config)
    config.color_scheme = M.nice_color_schemes[1]   -- lua tables have 1-indexing
end

return M
