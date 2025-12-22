local display = require("modules.display")
local system = require("modules.system")

-- Hotkey: Cmd + Option + Ctrl + D
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "D", function()
    display.connectSidecar()
    system.enableDND()
    system.launchApps()
    system.detachCopilot()
end)