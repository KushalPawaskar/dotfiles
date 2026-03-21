local wezterm = require("wezterm")
local colors = require("lua/colors")

local M = {}

function M.apply(config)
    -- font
    config.font_size = 12

    -- tabs
    config.hide_tab_bar_if_only_one_tab = true
    config.enable_tab_bar = true
    -- config.tab_bar_at_bottom = true
    config.use_fancy_tab_bar = false
    -- config.tab_max_width = 999

    -- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    --     local title = tab.active_pane.title
    --
    --     -- center title
    --     local padding = math.floor((max_width - #title) / 2)
    --
    --     if padding < 0 then
    --         padding = 0
    --     end
    --
    --     return {
    --         { Text = string.rep(" ", padding) .. title .. string.rep(" ", padding) },
    --     }
    -- end)

    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local title = tab.tab_title
        local is_active = tab.is_active

        -- fallback to default title if not renamed
        if title == nil or title == "" then
            title = tab.active_pane.title
        end

        local bg
        local fg

        -- tab coloring
        if is_active then
            bg = "#000000"
            fg = "#ffffff"
        else
            bg = "#444444"
            fg = "#999999"
        end

        -- apply special colors if tab has a custom title
        if tab.tab_title ~= nil and tab.tab_title ~= "" then
            if title == "edit" then
                bg = colors.vibrant.blue
                fg = "#000000"
            elseif title == "git" then
                bg = colors.vibrant.yellow
                fg = "#000000"
            elseif title == "vm" then
                bg = colors.vibrant.red
                fg = "#000000"
            elseif title == "sync" then
                bg = colors.vibrant.green
                fg = "#000000"
            elseif title == "ray" then
                bg = colors.vibrant.purple
                fg = "#000000"
            elseif title == "misc" then
                bg = colors.vibrant.orange
                fg = "#000000"
            end

            -- brighten active renamed tab
            if is_active then
                fg = "#ffffff"
            end
        end

        return {
            { Background = { Color = bg } },
            { Foreground = { Color = fg } },
            { Text = " " .. title .. " " },
        }
    end)

    -- window
    config.window_decorations = "RESIZE"    -- default: "TITLE | RESIZE"
    config.window_background_opacity = 0.90
    config.macos_window_background_blur = 7

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
