local wezterm = require("wezterm")
local colors = require("lua/colors")

local M = {}

function M.apply(config)
    config.leader = {
        key = ' ',
        mods = "SHIFT",
        timeout_milliseconds = 1000
    }
    

    config.key_tables = {
        -- sub-menu for commands starting with key c (after modifiers)
        c_mode = {
            {
                key = 's',      -- c s  (color scheme selector)
                action = wezterm.action.InputSelector{
                    title = "Select Color Scheme",
                    choices = (function()
                        local choices = {}
                        for _, name in ipairs(colors.nice_color_schemes) do
                            table.insert(choices, { label = name })
                        end
                        return choices
                    end)(),
                    action = wezterm.action_callback(function(window, pane, id, label)
                        if label then
                            local overrides = window:get_config_overrides() or {}
                            overrides.color_scheme = label
                            window:set_config_overrides(overrides)
                        end
                        window:perform_action(wezterm.action.PopKeyTable, pane)
                    end),
                },
            },
            { key = "Escape", action = wezterm.action.PopKeyTable },    -- c <esc>
        },
        -- sub-menu for commands starting with key t (after modifiers)
        t_mode = {
            {
                key = 't',      -- t t (toggle enable_tab_bar)
                action = wezterm.action_callback(function(window, pane)
                    local overrides = window:get_config_overrides() or {}
                    overrides.enable_tab_bar = not overrides.enable_tab_bar
                    window:set_config_overrides(overrides)
                    window:perform_action(wezterm.action.PopKeyTable, pane)
                end),
            },
            {
                key = "r",      -- t r (rename tab)
                action = wezterm.action.PromptInputLine {
                    description = "Rename Tab",
                    action = wezterm.action_callback(function(window, pane, line)
                        if line then
                            window:active_tab():set_title(line)
                        end
                    end),
                },
            },
            {
                key = "s",      -- t s (tab switcher)
                action = wezterm.action.ShowTabNavigator,
            },
            { key = "Escape", action = wezterm.action.PopKeyTable },    -- t <esc>
        },
        -- sub-menu for commands starting with key s (after modifiers)
        s_mode = {
            {
                key = "v",      -- s v (split horizontally)
                action = wezterm.action.SplitHorizontal{ domain = "CurrentPaneDomain" },
            },
            {
                key = "h",      -- s h (split vertically)
                action = wezterm.action.SplitVertical{ domain = "CurrentPaneDomain" },
            },
            {
                key = "x",      -- s x (close active pane)
                action = wezterm.action.CloseCurrentPane{ confirm = true },
            },
            { key = "Escape", action = wezterm.action.PopKeyTable },    -- s <esc>
        },
    }

    config.keys = {
        {
            key = 'p',      -- command palette
            mods = "LEADER",
            action = wezterm.action.ActivateCommandPalette
        },
        {
            key = 'c',      -- c_mode (check key_tables above)
            mods = "LEADER",
            action = wezterm.action.ActivateKeyTable{
                name = "c_mode",
                one_shot = true
            }
        },
        {
            key = 't',      -- t_mode (check key_tables above)
            mods = "LEADER",
            action = wezterm.action.ActivateKeyTable{
                name = "t_mode",
                one_shot = true
            }
        },
        {
            key = "UpArrow",    -- scroll up
            mods = "SUPER",
            action = wezterm.action.ScrollByLine(-1)
        },
        {
            key = "DownArrow",    -- scroll down
            mods = "SUPER",
            action = wezterm.action.ScrollByLine(1)
        },
        {
            key = "UpArrow",    -- jump to previous prompt line
            mods = "SUPER|SHIFT",
            action = wezterm.action.ScrollToPrompt(-1)
        },
        {
            key = "DownArrow",    -- jump to next prompt line
            mods = "SUPER|SHIFT",
            action = wezterm.action.ScrollToPrompt(1)
        },
        {
            key = "LeftArrow",      -- go backward one word
            mods = "OPT",
            action = wezterm.action.SendString("\x1bb")
        },
        {
            key = "RightArrow",      -- go forward one word
            mods = "OPT",
            action = wezterm.action.SendString("\x1bf")
        },
        {
            key = "[",       -- copy mode
            mods = "LEADER",
            action = wezterm.action.ActivateCopyMode
        },
        {
            key = "s",      -- s_mode (key_tables)
            mods = "LEADER",
            action = wezterm.action.ActivateKeyTable{
                name = "s_mode",
                one_shot = true
            }
        },
        {
            key = "h",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Left"
        },
        {
            key = "j",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Down"
        },
        {
            key = "k",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Up"
        },
        {
            key = "l",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection "Right"
        },
        {
            key = "H",
            mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Left", 5 },
        },
        {
            key = "L",
            mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Right", 5 },
        },
        {
            key = "K",
            mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Up", 5 },
        },
        {
            key = "J",
            mods = "LEADER",
            action = wezterm.action.AdjustPaneSize { "Down", 5 },
        },
    }

    config.mouse_bindings = {
        {
            event = { Down = { streak = 4, button = "Left" } },
            mods = "NONE",
            action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
        },
    }
end

return M
