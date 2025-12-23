hs.logger.defaultLogLevel = "info"

local config = require("config")

local display = require("modules.display")
local system = require("modules.system")

-- Hotkey: Cmd + Option + Ctrl + A
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A", function()
    
    hs.alert.show("Starting Automation Sequence...")

    display.connectSidecar()
    system.enableDND()

    hs.timer.doAfter(2, function()
        system.launchApps()
        
        hs.urlevent.openURL("https://github.com/sandeepkumaraau")
        hs.urlevent.openURL("https://gemini.google.com")
        
    end)

    hs.timer.doAfter(4, function()
        system.fullscreenchrome()
    end)

    hs.timer.doAfter(5, function()
        system.detachCopilot()
    end)





end)

hs.alert.show("Hammerspoon Automation Ready")