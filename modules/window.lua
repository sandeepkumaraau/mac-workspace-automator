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

local function fullscreen(win, screen)
    if not win then return end
    win:raise()
    win:focus()
    win:moveToScreen(screen)
    win:setFullScreen(true)
    hs.alert.show("Set VS Code to Fullscreen")
end



-----------------------------------------


function module.fullscreenchrome()
    local monitor = findScreenByName(config.monitorName)
    hs.timer.waitUntil(
        function() return hs.application.get(config.apps.browser) ~= nil end,
        function()
            local chrome = hs.application.get(config.apps.browser)
            local windows = chrome:allWindows() or {}
            fullscreen(windows[1], monitor)
            hs.alert.show("Set Chrome to Fullscreen")
        end
    )
end

------------------------------------------

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
                hs.timer.doAfter(2, function()
                    if windows[1] and ipadScreen then fullscreen(windows[1], ipadScreen) end
                    if windows[2] then fullscreen(windows[2], mainScreen) end
                end)
                hs.alert.show("VS Code has multiple windows open. Aborting detach.")
                return
            end

            local win = windows[1]
            local winId = win:id()
            VSCode:activate()

            hs.timer.doAfter(0.8, function()
                hs.eventtap.keyStroke({"control","command"}, "B") -- detach co-pilot shortcut
                hs.alert.show("Detached Co-Pilot in VS Code")

                hs.timer.doAfter(0.8, function()
                    local app2 = hs.application.get(config.apps.code)
                    if not app2 then return end
                    local newWin
                    for _, w in pairs(app2:allWindows() or {}) do
                        if w:id() ~= winId then
                            newWin = w
                            break
                        end
                    end

                    if newWin and ipadScreen then

                        fullscreen(newWin, ipadScreen)
                        hs.alert.show("Moved Co-pilot window to iPad")
                    
                    else
                        hs.alert.show("No additional window found for Co-Pilot")
                    end
                    fullscreen(win, mainScreen)

                end)
            end)
        end,
        0.5, -- check interval
        10   -- timeout seconds
    )
end

return module