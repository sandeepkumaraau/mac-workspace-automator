local display = require("modules.display")
local system = require("modules.system")
local windows = require("modules.windows")

-- Hotkey: Cmd + Option + Ctrl + D
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


    hs.timer.doAfter(7, function()
        windows.arrange()
    end)

end)

hs.alert.show("Hammerspoon Automation Ready")