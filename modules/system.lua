local config = require("config")
local module = {}

function module.enableDND()
    hs.execute("shortcuts run 'DND'")
    hs.alert.show("Do Not Disturb Enabled")
end


-- Launch apps
function module.launchApps()
    hs.application.launchOrFocus(config.apps.code)
    hs.application.launchOrFocus(config.apps.browser)
    hs.alert.show("Launched Apps")
end


-- Detach co-pilot in vs code
function module.detachCopilot()
    local VSCode = hs.application.get(config.apps.code)

    if VSCode then
        VSCode:activate()
        hs.timer.doAfter(0.5, function() hs.eventtap.keyStroke({"control","command"}, "B") 
        hs.alert.show("Detached Copilot Sidebar")
        end)
    else
        hs.alert.show("VS Code is not running")
    end
end

return module
