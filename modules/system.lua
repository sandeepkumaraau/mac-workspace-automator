local config = require("config")
local module = {}



local function findScreenByName(name)
    if not name or name == "" then return nil end
    local needle = name:lower()
    for _, s in ipairs(hs.screen.allScreens()) do
        local n = (s:name() or ""):lower()
        if n:find(needle, 1, true) then return s end
    end
    return nil
end

function module.enableDND()
    hs.execute("shortcuts run 'DND'")
    hs.alert.show("Do Not Disturb Enabled")
end


-- Launch apps
function module.launchApps()
    hs.application.launchOrFocusByBundleID(config.apps.code)
    hs.application.launchOrFocusByBundleID(config.apps.browser)
    hs.alert.show("Launched Apps")
end

function module.fullscreenchrome()
    hs.timer.waitUntil(
        function() return hs.application.get(config.apps.browser) ~= nil end,
        function()
            local chrome = hs.application.get(config.apps.browser)
            if not chrome then return end
            local windows = chrome:allWindows() or {}

            for _, win in pairs(windows) do
                win:setFullScreen(true)
            end
            hs.alert.show("Set Chrome to Fullscreen")
        end,
        0.5, -- check interval
        10   -- timeout seconds
    )
end

local function fullscreenVscode(win, screen)
    if not win then return end
    win:raise()
    win:focus()
    win:moveToScreen(screen)
    win:setFullScreen(true)
    hs.alert.show("Set VS Code to Fullscreen")
end


function module.detachCopilot()
    local ipadScreen = findScreenByName(config.ipadName)
    local mainScreen = hs.screen.primaryScreen()

    hs.timer.waitUntil(
        function() return hs.application.get(config.apps.code) ~= nil end,
        function()
            local VSCode = hs.application.get(config.apps.code)
            if not VSCode then return end
            local windows = VSCode:allWindows() or {}

            if #windows ~= 1 then
                hs.timer.doAfter(3, function()
                    if windows[1] and ipadScreen then fullscreenVscode(windows[1], ipadScreen) end
                    if windows[2] then fullscreenVscode(windows[2], mainScreen) end
                end)
                hs.alert.show("VS Code has multiple windows open. Aborting detach.")
                return
            end

            local win = windows[1]
            local winId = win:id()
            VSCode:activate()

            hs.timer.doAfter(1, function()
                hs.eventtap.keyStroke({"control","command"}, "B") -- detach co-pilot shortcut
                hs.alert.show("Detached Co-Pilot in VS Code")

                hs.timer.doAfter(0.3, function()
                    local newWin = nil
                    for _, w in pairs(VSCode:allWindows() or {}) do
                        if w:id() ~= winId then
                            newWin = w
                            break
                        end
                    end

                    if newWin then
                        if not ipadScreen then
                            hs.alert.show("iPad screen not found: " .. tostring(config.ipadName))
                            return
                        end
                        newWin:raise()
                        newWin:focus()
                        newWin:moveToScreen(ipadScreen)
                        newWin:setFullScreen(true)
                        hs.alert.show("Moved Co-pilot window to iPad")

                        hs.timer.doAfter(0.5, function()
                            fullscreenVscode(win, mainScreen)
                            hs.alert.show("Focused back to main VS Code window")
                        end)
                    else
                        hs.alert.show("No additional window found for Co-Pilot")
                    end
                end)
            end)
        end,
        0.5, -- check interval
        10   -- timeout seconds
    )
end


return module
