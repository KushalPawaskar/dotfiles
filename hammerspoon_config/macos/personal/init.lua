hs.window.animationDuration = 0

local QUAKE_TITLE = "wezterm-quake"
local QUAKE_HEIGHT_RATIO = 0.35
local WEZTERM_BUNDLE = "com.github.wez.wezterm"

local quakeVisible = false
local previousApp = nil
local quakeAppPid = nil

local function findQuakeAppAndWindow()
    if quakeAppPid then
        local app = hs.application.applicationForPID(quakeAppPid)
        if app then
            for _, win in ipairs(app:allWindows()) do
                if string.find(win:title(), QUAKE_TITLE, 1, true) then
                    return app, win
                end
            end
        end
        quakeAppPid = nil
    end

    for _, app in ipairs(hs.application.applicationsForBundleID(WEZTERM_BUNDLE)) do
        for _, win in ipairs(app:allWindows()) do
            if string.find(win:title(), QUAKE_TITLE, 1, true) then
                quakeAppPid = app:pid()
                return app, win
            end
        end
    end
    return nil, nil
end

local function positionQuakeWindow(win)
    local screen = hs.screen.mainScreen()
    local max = screen:fullFrame()
    win:setFrame(hs.geometry.rect(max.x, max.y, max.w, max.h * QUAKE_HEIGHT_RATIO))
end

local function ensureNormalWeztermRunning()
    local wez = hs.application.find("WezTerm", true)
    if not wez then
        hs.application.open(WEZTERM_BUNDLE)
    end
end

local function launchQuakeWindow()
    ensureNormalWeztermRunning()
    hs.timer.doAfter(0.5, function()
        hs.task.new("/bin/sh", function() end, {
            "-c",
            "export WEZTERM_QUAKE=1;"
            .. " /Applications/WezTerm.app/Contents/MacOS/wezterm"
            .. " start --always-new-process"
            .. " --position active:0,0",
        }):start()
    end)
end

local function toggleQuakeTerminal()
    local app, win = findQuakeAppAndWindow()

    if not app then
        previousApp = hs.application.frontmostApplication()
        launchQuakeWindow()
        hs.timer.doAfter(2.5, function()
            local a, w = findQuakeAppAndWindow()
            if a and w then
                positionQuakeWindow(w)
                a:activate()
                w:focus()
                quakeVisible = true
            end
        end)
        return
    end

    if quakeVisible then
        app:hide()
        quakeVisible = false
        if previousApp then
            previousApp:activate()
            previousApp = nil
        end
    else
        local frontApp = hs.application.frontmostApplication()
        if frontApp and frontApp:bundleID() ~= WEZTERM_BUNDLE then
            previousApp = frontApp
        end
        app:unhide()
        hs.timer.doAfter(0.2, function()
            positionQuakeWindow(win)
            win:raise()
            app:activate()
            win:focus()
        end)
        quakeVisible = true
    end
end

hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "H", toggleQuakeTerminal)
