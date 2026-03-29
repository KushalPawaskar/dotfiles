hs.window.animationDuration = 0

local Logger = hs.logger.new("default", "info")
local spaces = require("hs.spaces")

local QUAKE_TITLE = "quake" 
local MAIN_WEZTERM_BUNDLE = "com.github.wez.wezterm"

-- Pointing directly at the clone to prevent Dock multiplication
local wezterm_exec = "/Applications/WezTermQuake.app/Contents/MacOS/wezterm"

local previousApp = nil
local quakeAppPid = nil

local function findQuakeAppAndWindow()
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

    -- Broad search finds both your main app and the clone seamlessly
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
    -- Ensures your background multiplexer is alive so Quake can attach to it
    local wez = hs.application.find(MAIN_WEZTERM_BUNDLE, true)
    if not wez then
        hs.application.open(MAIN_WEZTERM_BUNDLE)
    end
end

local function launchQuakeWindow()
    ensureNormalWeztermRunning()
    hs.timer.doAfter(0.5, function()
        hs.task.new("/bin/sh", function() end, {
            "-c",
            "export WEZTERM_QUAKE=1; " .. wezterm_exec .. " start --always-new-process --class org.wezfurlong.wezterm.quake --workspace quake --domain unix --attach"
        }):start()
    end)
end

local function toggleQuakeTerminal()
    local app, win = findQuakeAppAndWindow()

    if not app or not win then
        previousApp = hs.application.frontmostApplication()
        launchQuakeWindow()
        
        local count = 0
        hs.timer.waitUntil(
            function()
                count = count + 1
                if count >= 50 then return true end 
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
            -- THE FIX: Kill immediately purges it from the App Switcher.
            -- Because we are using the Clone, Recent Apps only caches 1 single icon.
            app:kill()
            quakeAppPid = nil 
            
            if previousApp then
                previousApp:activate()
                previousApp = nil
            end
        else
            positionQuakeWindow(win)
            app:activate()
            win:focus()
        end
    else
        spaces.moveWindowToSpace(win:id(), currentSpace)
        hs.timer.doAfter(0.05, function()
            positionQuakeWindow(win)
            app:activate()
            win:focus()
        end)
    end
end

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "H", toggleQuakeTerminal)
