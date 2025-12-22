hs.logger.defaultLogLevel = "info"

local config = require("config")

local display = require("modules.display")
local system = require("modules.system")
local windows = require("modules.windows")

-- Hotkey: Cmd + Option + Ctrl + A
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A", function()
    
    hs.alert.show("Starting Automation Sequence...")

    display.connectSidecar()
    system.enableDND()

    hs.timer.doAfter(2, function()
        system.launchApps()
        -- Open Gemini URL specifically
        hs.urlevent.openURL("https://gemini.google.com")
    end)

    hs.timer.doAfter(5, function()
        system.detachCopilot()
    end)


   hs.timer.waitUntil(
    function() return hs.screen.find(config.ipadName) ~= nil end,
    function() windows.arrange() end,
    0.5, 15 -- check every 0.5s, timeout 15s
    )

end)

hs.alert.show("Hammerspoon Automation Ready")