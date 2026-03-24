hs.window.animationDuration = 0

local Logger = hs.logger.new("default", "info")
local spaces = require("hs.spaces")

local QUAKE_TITLE = "quake" 
local WEZTERM_BUNDLE = "com.github.wez.wezterm"
local wezterm_exec = "/Applications/WezTerm.app/Contents/MacOS/wezterm"

local previousApp = nil
local quakeAppPid = nil

local function findQuakeAppAndWindow()
    -- 1. Try our cached PID
    if quakeAppPid then
        local app = hs.application.applicationForPID(quakeAppPid)
        if app then
            for _, win in ipairs(app:allWindows()) do
                if win:title() and string.find(win:title():lower(), QUAKE_TITLE, 1, true) then
                    return app, win
                end
            end
        end
        quakeAppPid = nil
    end

    -- 2. Broad search to bypass corporate macOS restrictions
    for _, app in ipairs(hs.application.runningApplications()) do
        local name = app:name() or ""
        if string.find(name:lower(), "wezterm") then
            for _, win in ipairs(app:allWindows()) do
                local title = win:title()
                if title and string.find(title:lower(), QUAKE_TITLE, 1, true) then
                    quakeAppPid = app:pid() 
                    return app, win
                end
            end
        end
    end
    return nil, nil
end

local function positionQuakeWindow(win)
    if not win then return end
    
    local screen = hs.mouse.getCurrentScreen()
    local max = screen:frame()
    local f = win:frame()
    
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h * 0.4

    win:setFrame(f, 0)
    
    -- The 1-Pixel Jiggle to force WezTerm's internal grid redraw
    hs.timer.doAfter(0.05, function()
        if win then
            f.h = f.h + 1
            win:setFrame(f, 0)
            hs.timer.doAfter(0.05, function()
                if win then
                    f.h = f.h - 1
                    win:setFrame(f, 0)
                end
            end)
        end
    end)
end

local function ensureNormalWeztermRunning()
    local wez = hs.application.find(WEZTERM_BUNDLE, true)
    if not wez then
        hs.application.open(WEZTERM_BUNDLE)
    end
end

local function launchQuakeWindow()
    ensureNormalWeztermRunning()
    hs.timer.doAfter(0.5, function()
        -- MULTIPLEXER ADDED: This ensures the session survives when the app is killed
        hs.task.new("/bin/sh", function() end, {
            "-c",
            "export WEZTERM_QUAKE=1; " .. wezterm_exec .. " start --always-new-process --class org.wezfurlong.wezterm.quake --workspace quake --domain unix --attach"
        }):start()
    end)
end

local function toggleQuakeTerminal()
    local app, win = findQuakeAppAndWindow()

    -- 1. IF IT IS NOT RUNNING (Spawn & Attach)
    if not app or not win then
        previousApp = hs.application.frontmostApplication()
        launchQuakeWindow()
        
        -- Smart Polling: Snaps instantly instead of blindly waiting 2.5s
        local count = 0
        hs.timer.waitUntil(
            function()
                count = count + 1
                if count >= 50 then return true end -- Max wait of 5 seconds
                local a, w = findQuakeAppAndWindow()
                return w ~= nil
            end,
            function()
                local a, w = findQuakeAppAndWindow()
                if a and w then
                    hs.timer.doAfter(0.1, function()
                        positionQuakeWindow(w)
                        a:activate()
                        w:focus()
                    end)
                else
                    Logger.w("Failed to find window after spawning.")
                end
            end,
            0.1
        )
        return
    end

    -- 2. IF IT IS RUNNING (Kill or Focus)
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
            -- THE EXIT BEHAVIOR: Completely destroy the GUI process
            app:kill()
            quakeAppPid = nil 
            
            -- Return focus to whatever you were doing before
            if previousApp then
                previousApp:activate()
                previousApp = nil
            end
        else
            -- It's visible on this desktop, but you clicked away. Bring it back to front.
            positionQuakeWindow(win)
            app:activate()
            win:focus()
        end
    else
        -- It's visibly sitting on another desktop. Teleport it to us.
        spaces.moveWindowToSpace(win:id(), currentSpace)
        hs.timer.doAfter(0.05, function()
            positionQuakeWindow(win)
            app:activate()
            win:focus()
        end)
    end
end

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "H", toggleQuakeTerminal)
