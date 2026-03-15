local wezterm = require("wezterm")
local colors = require("lua/colors")

local M = {}

M.is_quake = os.getenv("WEZTERM_QUAKE") == "1"

function M.apply(config)
    if not M.is_quake then
        return
    end

    config.enable_tab_bar = false
    config.window_decorations = "RESIZE"
    config.window_background_opacity = 0.75
    -- config.macos_window_background_blur = 30
    config.window_close_confirmation = "NeverPrompt"
    config.color_scheme = colors.nice_color_schemes[3]

    -- disable new window/tab shortcuts so the quake instance stays single-window
    config.keys = config.keys or {}
    table.insert(config.keys, { key = "n", mods = "CMD", action = wezterm.action.DisableDefaultAssignment })
    -- table.insert(config.keys, { key = "t", mods = "CMD", action = wezterm.action.DisableDefaultAssignment })

    wezterm.on("format-window-title", function(tab, pane, tabs, panes, cfg)
        return "wezterm-quake: " .. tab.active_pane.title
    end)
end

return M
