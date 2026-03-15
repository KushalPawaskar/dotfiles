-- ref: https://www.josean.com/posts/how-to-setup-wezterm-terminal

-- wezterm API
local wezterm = require("wezterm")

-- config table
local config = wezterm.config_builder()

-- import modules
local appearance = require("lua/appearance")
local colors = require("lua/colors")
local keys = require("lua/keys")
local quake = require("lua/quake")  -- iterm2 like hotkey window (quake style dropdown)

-- apply configuration from modules
appearance.apply(config)
colors.apply(config)
keys.apply(config)
quake.apply(config)

-- broadcast input

return config
