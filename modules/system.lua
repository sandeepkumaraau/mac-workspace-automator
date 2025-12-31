local config = require("config")
local module = {}


-- Enable Do Not Disturb
function module.enableDND()
    hs.execute("shortcuts run 'DND'")
    hs.alert.show("Do Not Disturb Enabled")
end

function module.enableGoodnotes()
    hs.execute("shortcuts run 'set notesapp'")
    hs.alert.show("Goodnotes Setup Enabled")
end


-- Launch essential applications

function module.launchVScode()
    hs.application.launchOrFocusByBundleID(config.apps.code)
    hs.alert.show("Launched VSCode")
end

function module.launchChrome()
    hs.application.launchOrFocusByBundleID(config.apps.chrome)
    hs.alert.show("Launched Chrome")
end

function module.launchSafari()
    hs.application.launchOrFocusByBundleID(config.apps.safari)
    hs.alert.show("Launched Safari")
end

function module.launchOutlook()
    hs.application.launchOrFocusByBundleID(config.apps.outlook)
    hs.alert.show("Launched Outlook")
end

function module.launchMail()
    hs.application.launchOrFocusByBundleID(config.apps.mail)
    hs.alert.show("Launched Mail")
end



return module
