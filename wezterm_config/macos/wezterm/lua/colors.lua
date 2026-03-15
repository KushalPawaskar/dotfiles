local M = {}

-- export nice color schemes so that it is accessible to InputSelector in keys.lua
M.nice_color_schemes = {
    "Argonaut (Gogh)",
    "ayu",
    "Builtin Pastel Dark",
    "Cupertino (base16)",   -- light
    "ChallengerDeep",
    "Cobalt 2 (Gogh)",
}

function M.apply(config)
    config.color_scheme = M.nice_color_schemes[5]   -- lua tables have 1-indexing
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
