local wezterm = require("wezterm")

local M = {}

function M.apply(config)
    -- font
    config.font_size = 12

    -- tabs
    config.hide_tab_bar_if_only_one_tab = true
    config.enable_tab_bar = true
    -- config.tab_bar_at_bottom = true

    -- window
    config.window_decorations = "RESIZE"    -- default: "TITLE | RESIZE"
    config.window_background_opacity = 0.90
    -- config.macos_window_background_blur = 1

    -- visual feedback for leader
    wezterm.on("update-right-status", function(window, pane)
        local status = ''
        if window:leader_is_active() then
            status = " ⚡ LEADER ACTIVE ⚡ "
        end

        window:set_right_status(wezterm.format({
            { Foreground = { Color = "#ffaa00" } },
            { Attribute = { Intensity = "Bold" } },
            { Text = status },
        }))
    end)

    -- scrolling
    config.enable_scroll_bar = true
end

return M
