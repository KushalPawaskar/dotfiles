-- temporary diagnostic logger for tracking down why leader-t-c tab colors
-- reset overnight. appends one line per event to M.LOG_PATH.
--
-- how to read the log: colors.lua calls M.log() at module top-level, which
-- runs every time wezterm (re)executes the config -- i.e. every time
-- tab_colors resets to {}. compare pid/boottime across consecutive
-- "colors.lua loaded" lines:
--   - boottime changed              -> the Mac actually rebooted
--   - boottime same, pid changed    -> wezterm process itself restarted (crash/quit+reopen)
--   - boottime same, pid same       -> in-process config reload (check for a
--                                      window-config-reloaded line at the same time)
--
-- safe to delete this file and its require()/apply() call sites once the
-- cause is found.
local wezterm = require("wezterm")

local M = {}

M.LOG_PATH = (os.getenv("HOME") or "") .. "/.wezterm_tab_color_debug.log"

local function safe_pid()
    local ok, pid = pcall(function() return wezterm.pid() end)
    if ok and pid then
        return tostring(pid)
    end
    return "?"
end

local function boottime()
    local ok, success, stdout = pcall(wezterm.run_child_process, { "sysctl", "-n", "kern.boottime" })
    if ok and success and stdout then
        return (stdout:gsub("%s+$", ""))
    end
    return "unknown"
end

-- append a single diagnostic line; never throws, so it's safe to call from
-- module top-level code (e.g. colors.lua) where an uncaught error would
-- break the entire wezterm config
function M.log(event)
    pcall(function()
        local f = io.open(M.LOG_PATH, "a")
        if not f then
            return
        end
        f:write(string.format(
            "[%s] pid=%-8s event=%-45s boottime=%s\n",
            os.date("%Y-%m-%d %H:%M:%S"),
            safe_pid(),
            event,
            boottime()
        ))
        f:close()
    end)
end

function M.apply(config)
    wezterm.on("gui-startup", function()
        M.log("gui-startup (brand new wezterm process)")
    end)

    wezterm.on("window-config-reloaded", function(window)
        local ok, win_id = pcall(function() return window:window_id() end)
        M.log("window-config-reloaded win=" .. (ok and tostring(win_id) or "?"))
    end)
end

return M
