local wezterm = require("wezterm")
local colors = require("lua/colors")

local mux = wezterm.mux
local quake = "quake"

local M = {}

-- Read the environment variable injected by Hammerspoon
M.is_quake = os.getenv("WEZTERM_QUAKE") == "1"

function M.apply(config)
    if not M.is_quake then
        return
    end

    -- quake specific styling
    config.window_background_opacity = 0.75
    config.macos_window_background_blur = 0
    config.color_scheme = colors.nice_color_schemes[3]

    -- Crucial: prevent WezTerm from asking "Are you sure?"
    config.window_close_confirmation = 'NeverPrompt'

    wezterm.on("format-window-title", function()
        return quake
    end)
end

return M
