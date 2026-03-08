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
                            window:set_config_overrides({ color_scheme = label })
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
                    overrides.enable_tab_bar = not (overrides.enable_tab_bar ~= false)
                    window:set_config_overrides(overrides)
                    window:perform_action(wezterm.action.PopKeyTable, pane)
                end),
            },
            { key = "Escape", action = wezterm.action.PopKeyTable },    -- t <esc>
        }
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
    }
end

return M
