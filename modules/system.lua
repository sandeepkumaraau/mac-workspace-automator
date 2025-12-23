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


-- Detach co-pilot in VS Code
function module.detachCopilot()
    hs.timer.waitUntil(
        function() return hs.application.get(config.apps.code) ~= nil end,
        function()
            local VSCode = hs.application.get(config.apps.code)
            if not VSCode then return end
            local windows = VSCode:allWindows() or {}

            if #windows ~= 1 then
                hs.alert.show("VS Code has multiple windows open; cannot detach Co-Pilot automatically.")
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
                        local ipadScreen = findScreenByName(config.ipadName)
                        if not ipadScreen then
                            hs.alert.show("iPad screen not found: " .. tostring(config.ipadName))
                            return
                        end
                        
                        newWin:raise()
                        newWin:focus()
                        newWin:moveToScreen(ipadScreen)
                        newWin:setFullScreen(true)
                        hs.alert.show("Moved Co-pilot window to iPad")
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
