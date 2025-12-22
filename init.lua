local display = require("modules.display")

-- Hotkey: Cmd + Option + Ctrl + D
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "D", function()
    display.connectSidecar()
end)