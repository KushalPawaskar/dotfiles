local wezterm = require("wezterm")
local colors = require("lua/colors")

local mux = wezterm.mux
local quake = "quake"

local M = {}

function M.apply(config)
    -- Crucial: prevent WezTerm from asking "Are you sure?"
    config.window_close_confirmation = 'NeverPrompt'

    wezterm.on("format-window-title", function()
        local workspace = wezterm.mux.get_active_workspace()
        if workspace ~= quake then return nil end
        return quake
    end)
end

return M
