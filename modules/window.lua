local config = require("config")
local module = {}
hs.application.enableSpotlightForNameSearches(true)

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
    if not screen then 
       win:raise()
       win:focus()
       win:setFullScreen(true)
       return
    else
       win:raise()
       win:focus()
       win:moveToScreen(screen)
       win:setFullScreen(true)
    end
end



-----------------------------------------


function module.fullscreenchrome()
    local monitor = findScreenByName(config.monitorName)
    local mainScreen = hs.screen.primaryScreen()

    hs.timer.waitUntil(
        function()
            local app = hs.application.get(config.apps.chrome)
            return app and #(app:allWindows() or {}) > 0
        end,
        function()
            local chrome = hs.application.get(config.apps.chrome)
            local windows = chrome:allWindows() or {}

            for _, w in ipairs(windows) do
                if (w:title() or ""):lower():find("gemini") then
                    fullscreen(w, mainScreen)
                else
                    fullscreen(w, monitor)
                end
            end
        end,
        0.5, -- check interval
        4   -- timeout seconds


    )
end

function module.openGeminiWindow()
    hs.osascript.applescript([[
        tell application "Google Chrome"
            make new window
            tell front window
                set URL of active tab to "https://gemini.google.com"
            end tell
        end tell
    ]])
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
        3   -- timeout seconds
    )
end
-----------------------------------------

function module.fullscreenOutlook_Mail()
    local mainScreen = hs.screen.primaryScreen()

    hs.timer.waitUntil(
        function()
            local app1 = hs.application.get(config.apps.outlook)
            local app2 = hs.application.get(config.apps.mail)
            return (app1 and #(app1:allWindows() or {}) > 0) and (app2 and #(app2:allWindows() or {}) > 0)
        end,
        function()
            local outlook = hs.application.get(config.apps.outlook)
            local mail = hs.application.get(config.apps.mail)

            hs.alert.show("Fullscreening Outlook and Mail apps")

            for _, w in ipairs(outlook:allWindows() or {}) do
                fullscreen(w, mainScreen)
                hs.alert.show("Fullscreened Outlook")
            end

            for _, w in ipairs(mail:allWindows() or {}) do
                fullscreen(w, mainScreen)
                hs.alert.show("Fullscreened Mail")
            end
        end,
        0.5, -- check interval
        5   -- timeout seconds
    )
end

-- Helper to find button by text
local function findElementWithTitle(element, targetTitle)
    if not element then return nil end
    if element:attributeValue("AXTitle") == targetTitle or 
       element:attributeValue("AXValue") == targetTitle or 
       element:attributeValue("AXDescription") == targetTitle then
        return element
    end
    local children = element:attributeValue("AXChildren")
    if children then
        for _, child in ipairs(children) do
            local found = findElementWithTitle(child, targetTitle)
            if found then return found end
        end
    end
    return nil
end

function module.settingsPane()
    -- 1. Run the AppleScript that you confirmed works
    hs.osascript.applescript([[
        set theExtensionID to "com.apple.ControlCenter-Settings.extension"
        tell application "System Settings" to activate
        open location "x-apple.systempreferences:" & theExtensionID
    ]])

    local app = hs.application.get("System Settings")
    
    -- Wait briefly for the window to render
    hs.timer.doAfter(1, function()
        if not app then app = hs.application.get("System Settings") end
        
        local win = app:mainWindow()
        if win then
            local axWin = hs.axuielement.windowElement(win)

            -- 2. Find "Never". If not found, find "Always".
            local targetButton = findElementWithTitle(axWin, "Never")
            if not targetButton then
                targetButton = findElementWithTitle(axWin, "Always")
            end

            -- 3. Click and Toggle
            if targetButton then
                -- Click to OPEN the menu
                targetButton:performAction("AXPress")
                hs.timer.usleep(200000) -- Wait for menu to pop up

                -- Type the key to switch options
                if targetButton:attributeValue("AXValue") == "Never" then
                    hs.eventtap.keyStrokes("a") -- Switch to "Always"
                    hs.alert.show("Switched to Always")
                else
                    hs.eventtap.keyStrokes("n") -- Switch to "Never"
                    hs.alert.show("Switched to Never")
                end
                
                hs.timer.usleep(200000)
                hs.eventtap.keyStroke({}, "return") -- Confirm selection
            else
                hs.alert.show("Error: Button not found. Is the window visible?")
            end
        end
    end)
end
return module