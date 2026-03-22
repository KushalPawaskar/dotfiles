local Logger = hs.logger.new("default", "info")
local spaces = require("hs.spaces")
local quake = "quake"
local wez = {}

local wezterm_exec = "/opt/homebrew/bin/wezterm"
local is_spawning = false

function wez.placeWindow(win)
    if not win then return end

    local screen = hs.mouse.getCurrentScreen()
    local max = screen:frame()
    local f = win:frame()

    -- Target dimensions
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h * 0.4

    -- 1. Snap to the correct position and size
    win:setFrame(f, 0)

    -- 2. The 1-Pixel Jiggle: Force WezTerm to redraw its internal grid
    hs.timer.doAfter(0.05, function()
        if win then
            f.h = f.h + 1 -- Add 1 pixel
            win:setFrame(f, 0)

            hs.timer.doAfter(0.05, function()
                if win then
                    f.h = f.h - 1 -- Remove 1 pixel (back to perfect size)
                    win:setFrame(f, 0)
                end
            end)
        end
    end)
end

function wez.findWindow(workspace)
    local app = hs.application.get("wezterm")
    if not app then return nil end

    for _, win in ipairs(app:allWindows()) do
        if win:title() and string.find(win:title():lower(), workspace:lower()) then
            return win
        end
    end
    return nil
end

function wez.spawn(workspace)
    if is_spawning then return end
    is_spawning = true

    local args = {
        "start",
        "--class", "org.wezfurlong.wezterm." .. workspace,
        "--workspace", workspace,
        "--domain", "unix",
        "--attach"
    }
    hs.task.new(wezterm_exec, nil, args):start()

    local count = 0
    hs.timer.waitUntil(
        function()
            count = count + 1
            if count >= 50 then return true end
            return wez.findWindow(workspace) ~= nil
        end,
        function()
            is_spawning = false
            local win = wez.findWindow(workspace)
            if win then
                hs.timer.doAfter(0.1, function()
                    wez.placeWindow(win)
                    win:focus()
                end)
            else
                Logger.w("Failed to find window after spawning.")
            end
        end,
        0.1
    )
end

function wez.toggleFocus(workspace)
    if is_spawning then return end

    local win = wez.findWindow(workspace)

    if not win then
        wez.spawn(workspace)
        return
    end

    local currentSpace = spaces.focusedSpace()
    local winSpaces = spaces.windowSpaces(win:id())
    local isOnCurrentSpace = false

    if winSpaces then
        for _, s in ipairs(winSpaces) do
            if s == currentSpace then isOnCurrentSpace = true end
        end
    end

    if isOnCurrentSpace then
        local activeWin = hs.window.focusedWindow()
        if activeWin and activeWin:id() == win:id() then
            win:close()
        else
            hs.timer.doAfter(0.05, function()
                wez.placeWindow(win)
                win:focus()
            end)
        end
    else
        win:close()

        local count = 0
        hs.timer.waitUntil(
            function()
                count = count + 1
                if count >= 50 then return true end
                return wez.findWindow(workspace) == nil
            end,
            function()
                wez.spawn(workspace)
            end,
            0.05
        )
    end
end

hs.hotkey.bind({ "ctrl", "alt", "cmd", "shift" }, "H", function() wez.toggleFocus(quake) end)
