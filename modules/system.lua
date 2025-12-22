local config = require("config")
local module = {}

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


-- Detach co-pilot in vs code
function module.detachCopilot()
    hs.timer.waitUntil(
        function() return hs.application.get(config.apps.code) ~= nil end,
        function()
            local VSCode = hs.application.get(config.apps.code)
            VSCode:activate()
            hs.timer.doAfter(0.5, function()
                hs.eventtap.keyStroke({"control","command"}, "B")
                hs.alert.show("Detached Copilot Sidebar")
            end)
        end,
        0.2, -- check interval
        5    -- timeout seconds
    )
end

return module
