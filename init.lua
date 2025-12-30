hs.logger.defaultLogLevel = "info"

local config = require("config")

local display = require("modules.display")
local system = require("modules.system")
local window = require("modules.window")


hs.alert.show("Hammerspoon Automation Ready")


-- Automation Sequence for coding setup
-- Hotkey: Cmd + Option + Ctrl + C
hs.hotkey.bind({"cmd" , "ctrl"}, "C", function()
    
    hs.alert.show("Starting Coding Setup...")

    display.connectSidecar()
    system.enableDND()

    hs.timer.doAfter(2, function()
        system.launchChrome()
        
        hs.urlevent.openURL("https://github.com/sandeepkumaraau")
        hs.urlevent.openURL("https://gemini.google.com")

        system.launchVScode()
        
    end)

    hs.timer.doAfter(2, function()
        window.fullscreenchrome()
    end)

    hs.timer.doAfter(5, function()
        window.detachCopilot()
    end)

end)


-- Automation Sequence for Study setup
-- Hotkey: Cmd + Option + Ctrl + S
hs.hotkey.bind({"cmd" , "ctrl"}, "S", function()

    hs.alert.show("Starting Study Setup...")

    system.enableGoodnotes()

    hs.timer.doAfter(1, function()
        system.launchChrome()
        hs.urlevent.openURL("https://moodle.aau.at/login/index.php")

        window.fullscreenchrome()
        window.openGeminiWindow()
        
    end)


    hs.timer.doAfter(2, function()
        window.moveGeminiToPrimary()
    end)

end)


