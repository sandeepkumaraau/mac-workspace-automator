local config = require("config")
local module = {}


-- Enable Do Not Disturb
function module.enableDND()
    hs.execute("shortcuts run 'DND'")
    hs.alert.show("Do Not Disturb Enabled")
end



-- Launch essential applications

function module.launchVScode()
    hs.application.launchOrFocusByBundleID(config.apps.code)
    hs.alert.show("Launched VSCode")
end

function module.launchChrome()
    hs.application.launchOrFocusByBundleID(config.apps.browser)
    hs.alert.show("Launched Chrome")
end

function module.launchSafari()
    hs.application.launchOrFocusByBundleID(config.apps.safari)
    hs.alert.show("Launched Safari")
end

return module
