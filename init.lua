hs.logger.defaultLogLevel = "info"

local config = require("config")

local display = require("modules.display")
local system = require("modules.system")
local window = require("modules.window")


hs.alert.show("Hammerspoon Automation Ready")


-- Automation Sequence for coding setup
-- Hotkey: Cmd + Ctrl + C
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

    hs.timer.doAfter(3, function()
        window.detachCopilot()
    end)

end)


-- Automation Sequence for Study setup
-- Hotkey: Cmd + Ctrl + S
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




-- Automation Sequence for jobSearch setup
-- Hotkey: Cmd + Ctrl + J
hs.hotkey.bind({"cmd" , "ctrl"}, "J", function()

    hs.alert.show("Starting Job Search Setup...")
    
    display.connectSidecar()
    system.enableDND()

    hs.timer.doAfter(1, function()
        system.launchChrome()
        hs.urlevent.openURL("https://jobs.infineon.com/careers?domain=infineon.com")
        hs.urlevent.openURL("https://www.linkedin.com/jobs/")
        hs.urlevent.openURL("https://www.karriere.at/jobs")
        hs.urlevent.openURL("https://www.kaerntnerjobs.at/jobs?region=91,28,95,96,93,94,97,98,100,92,99&category=10,11,18,27")

        window.fullscreenchrome()
        window.openGeminiWindow()
    end)

    hs.timer.doAfter(2, function()
        window.moveGeminiToPrimary()
    end)

    hs.timer.doAfter(2, function()
        system.launchVScode()
    end)

    hs.timer.doAfter(3, function()
        window.detachCopilot()
    end)


end)