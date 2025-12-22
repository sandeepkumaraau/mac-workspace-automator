local config = require("config")
local module = {}

function module.arrange()
    
    local ipad = hs.screen.find(config.ipadName)
    local mainScreen = hs.screen.mainScreen()
    local monitor = hs.screen.find(config.monitorName)

    if not ipad then print("WARNING: iPad screen not found: " .. config.ipadName) end
    if not monitor then print("WARNING: Monitor screen not found: " .. config.monitorName) end

    local chrome = hs.application.get(config.apps.browser)
    if chrome and monitor then 

        for _, win in pairs(chrome:allWindows()) do
            win:moveToScreen(monitor)
            win:maximize()
        end
    end


    local code = hs.application.get(config.apps.code)
    if code then
        for _, win in pairs(code:allWindows()) do 
            local title = win:title()

            if string.find(title, "Chat") or string.find(title, "Copilot") then
                if ipad then
                    win:moveToScreen(ipad)
                    win:maximize()
                end
            else

                win:moveToScreen(mainScreen)
                win:maximize()
            end
        end
    end
    hs.alert.show("Windows Arranged")
end

return module
