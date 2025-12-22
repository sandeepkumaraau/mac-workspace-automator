local config = requires("config")
local module = {}



-- Function to connect Sidecar
function module.connectSidecar()
    local cmd = string.format('/opt/homebrew/bin/betterdisplaycli set -sidecarConnected=on -specifier="%s"', config.ipadName)

    hs.task.new("/bash/sh", function(exitCode, stdOut, stdErr)
        if exitCode == 0 then
            hs.notify.new({title="Display Module", informativeText="Sidecar connected to " .. config.ipadName}):send()
        else
            hs.notify.new({title="Display Module", informativeText="Failed to connect Sidecar: " .. stdErr}):send()
        end
    end, {"-c",cmd}):start()
end


-- Function to disconnect Sidecar
function module.disconnectSidecar()
    local cmd = string.format('/opt/homebrew/bin/betterdisplaycli set -sidecarConnected=off -specifier="%s"', config.ipadName)

    hs.execute(cmd)

end

return module
