local config = require("config")
local module = {}


-- Enable Do Not Disturb
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



return module
