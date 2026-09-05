local wezterm = require("wezterm")

local M = {}

-- export nice color schemes so that it is accessible to InputSelector in keys.lua
M.nice_color_schemes = {
    "Argonaut (Gogh)",
    "ayu",
    "Builtin Pastel Dark",
    "ChallengerDeep",
    "Cobalt 2 (Gogh)",
    "Dracula",
    "duckbones",
    "Ef-Autumn",
    "Ef-Day",       -- light
    "Ef-Winter",
    "Eldritch",
    "Elio (Gogh)"
}

function M.apply(config)
    config.color_scheme = M.nice_color_schemes[1]   -- lua tables have 1-indexing
end

-- Vibrant colors
M.vibrant = {
    blue   = "#5A87D9",  -- was #3B82F6
    red    = "#E06666",  -- was #EF4444
    yellow = "#E1C542",  -- was #FACC15
    purple = "#A17EDB",  -- was #8B5CF6
    orange = "#F28F5C",  -- was #F97316
    green  = "#4FB06A",  -- was #22C55E
    teal   = "#3DB0A9",  -- was #14B8A6
    pink   = "#EC82B5",  -- was #EC4899
    indigo = "#6C63D1",  -- was #4F46E5
    lime   = "#A5C652",  -- was #84CC16
    sky    = "#45A8D9",  -- was #0EA5E9
    rose   = "#F06C7C",  -- was #F43F5E
}

-- per-tab manual color overrides, keyed by tab_id as a string (set via leader t c)
-- lives here (not in keys.lua) so appearance.lua's format-tab-title can read it too
-- persisted to disk rather than wezterm.GLOBAL: config gets evaluated multiple times
-- per automatic reload (validation pass + apply pass) on this nightly build, and
-- GLOBAL isn't reliably shared across those passes. a plain JSON file survives
-- reloads within a session, which is all we want: colors are deliberately wiped on
-- every real process start (see gui-startup handler below) since tab_id isn't
-- stable across restarts and we don't want colors reappearing on the wrong fresh tab.
local TAB_COLORS_PATH = (os.getenv("HOME") or "") .. "/.wezterm_tab_colors.json"

local function load_tab_colors()
    local f = io.open(TAB_COLORS_PATH, "r")
    if not f then
        return {}
    end
    local content = f:read("*a")
    f:close()
    local ok, parsed = pcall(wezterm.json_parse, content)
    if ok and type(parsed) == "table" then
        return parsed
    end
    return {}
end

function M.save_tab_colors()
    local f = io.open(TAB_COLORS_PATH, "w")
    if not f then
        return
    end
    f:write(wezterm.json_encode(M.tab_colors))
    f:close()
end

function M.clear_tab_colors()
    M.tab_colors = {}
    M.save_tab_colors()
end

M.tab_colors = load_tab_colors()

-- wipe any colors left over from a previous session on every genuine fresh
-- process start (gui-startup does NOT fire during automatic config reloads,
-- only on a real launch)
wezterm.on("gui-startup", function()
    M.clear_tab_colors()
end)

-- Background / neutral colors
M.bg = {
    dark_gray      = "#1E1E2E",
    charcoal       = "#121212",
    slate          = "#2E2E3E",
    gunmetal       = "#23232B",
    dark_blue      = "#0F172A",
    dark_purple    = "#1E0F2E",
    navy           = "#10182F",
    soft_black     = "#0A0A0F",
}

return M
