local config = require("config")
local module = {}

function module.arrange()
    
    local ipad = hs.screen.find(config.ipadName)
    local mainScreen = hs.screen.primaryScreen()
    local monitor = hs.screen.find(config.monitorName)

    if not ipad then print("WARNING: iPad screen not found: " .. config.ipadName) end
    if not monitor then print("WARNING: Monitor screen not found: " .. config.monitorName) end

    local chrome = hs.application.get(config.apps.browser)
    if chrome and monitor then 

        for _, win in pairs(chrome:allWindows()) do
            win:moveToScreen(monitor)
            win:setFullScreen(true)
        end
    end

    local code = hs.application.get(config.apps.code)
    if code and mainScreen then
        for _, win in pairs(code:allWindows()) do
            win:moveToScreen(mainScreen)
            win:setFullScreen(true)
        end
    end 
    if ipad then
        hs.alert.show("Arranged windows with iPad connected")
    else
        hs.alert.show("Arranged windows (iPad not connected)")
    end
end
return module
