-- ref: https://www.josean.com/posts/how-to-setup-wezterm-terminal

-- wezterm API
local wezterm = require("wezterm")

-- config table
local config = wezterm.config_builder()

-- import modules
local appearance = require("lua/appearance")
local colors = require("lua/colors")
local keys = require("lua/keys")

-- apply configuration from modules
appearance.apply(config)
colors.apply(config)
keys.apply(config)

-- scrolling using keyboard (super + up/down), increase scrolling speed
-- jumping to prompt lines (super + shift + up/down)
-- hotkey window
-- broadcast input
-- tab color changing + renaming
-- dynamic tab sizing (to occupy entire tab bar for better visibility)

return config
